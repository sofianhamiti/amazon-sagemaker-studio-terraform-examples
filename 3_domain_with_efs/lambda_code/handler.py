import os


def lambda_handler(event, context):
    # Set the local folder path
    local_folder_path = "/mnt/lambda/home"

    print("CREATING FOLDER IN EFS")
    # Create the folder if it doesn't exist
    if not os.path.exists(local_folder_path):
        os.makedirs(local_folder_path)

    print("SET PERMISSIONS FOR SAGEMAKER TO SEE FOLDER")
    # Set the permissions of the folder to 777
    os.chmod(local_folder_path, 0o777)

    print("EFS FOLDER CREATION SUCCESSFULL")
    return {"statusCode": 200, "body": "EFS Folder Creation Successful"}
