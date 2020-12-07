!pip install turicreate

"""# Making sure to use the GPU"""

!pip uninstall -y mxnet

!pip install mxnet-cu100==1.4.0.post0

"""# Unzip the folder"""

!unzip -uq "/content/face.zip" -d "/content/face"

"""## Import the .CSV file and format the dataset to create an sframe folder that will be user during training"""

import turicreate as tc
import os

IMAGES_DIR = '/content/face/face' # Change if applicable
csv_path = '/content/annotations.csv' # assumes CSV column format is image,id,name,xMin,xMax,yMin,yMax
csv_sf = tc.SFrame.read_csv(csv_path)

def row_to_bbox_coordinates(row):
    """
    Takes a row and returns a dictionary representing bounding
    box coordinates:  (center_x, center_y, width, height)  e.g. {'x': 100, 'y': 120, 'width': 80, 'height': 120}
    """
    return {'x': row['xMin'] + (row['xMax'] - row['xMin'])/2,
            'width': (row['xMax'] - row['xMin']),
            'y': row['yMin'] + (row['yMax'] - row['yMin'])/2,
            'height': (row['yMax'] - row['yMin'])}

csv_sf['coordinates'] = csv_sf.apply(row_to_bbox_coordinates)
# delete no longer needed columns
del csv_sf['id'], csv_sf['xMin'], csv_sf['xMax'], csv_sf['yMin'], csv_sf['yMax']
# rename columns
csv_sf = csv_sf.rename({'name': 'label', 'image': 'name'})

# Load all images in random order
sf_images = tc.image_analysis.load_images(IMAGES_DIR, recursive=True,
    random_order=True)

# Split path to get filename
info = sf_images['path'].apply(lambda path: os.path.basename(path).split('/')[:1])

# Rename columns to 'name'
info = info.unpack().rename({'X.0': 'name'})

# Add to our main SFrame
sf_images = sf_images.add_columns(info)

# Original path no longer needed
del sf_images['path']

# Combine label and coordinates into a bounding box dictionary
csv_sf = csv_sf.pack_columns(['label', 'coordinates'], new_column_name='bbox', dtype=dict)

# Combine bounding boxes of the same 'name' into lists
sf_annotations = csv_sf.groupby('name',
    {'annotations': tc.aggregate.CONCAT('bbox')})

# Join annotations with the images. Note, some images do not have annotations,
# but we still want to keep them in the dataset. This is why it is important to
# a LEFT join.
sf = sf_images.join(sf_annotations, on='name', how='left')

# The LEFT join fills missing matches with None, so we replace these with empty
# lists instead using fillna.
sf['annotations'] = sf['annotations'].fillna([])

# Save SFrame
sf.save('/content/face.sframe')

"""# Train the model"""

import turicreate as tc

tc.config.set_num_gpus(-1)

# Load the data
data =  tc.SFrame('face.sframe')

# Make a train-test split
train_data, test_data = data.random_split(0.8)

# Create a model
model = tc.object_detector.create(train_data)

# Save predictions to an SArray
predictions = model.predict(test_data)

# Evaluate the model and save the results into a dictionary
metrics = model.evaluate(test_data)

# Save the model for later use in Turi Create
model.save('model_face_turi.model')

# Export for use in Core ML
model.export_coreml('model_face_turi.mlmodel')

"""# Download the .mlmodel file """

from google.colab import files
files.download('/content/model_face_turi.mlmodel')

!zip -r "/content/model_face_turi_model.zip" "/content/model_face_turi.model"