import os


def lambda_handler(event, context):
    """
    This function is a Lambda handler that creates a folder in an Amazon Elastic File System (EFS) mount point.
    It sets the permissions of the folder to 777, allowing read, write, and execute access for all users.
    """

    # Set the local folder path
    efs_folder_path = (
        f"{os.environ['lambda_mount_path']}{os.environ['efs_folder_path']}"
    )

    print("CREATING FOLDER IN EFS")

    # Create the folder if it doesn't exist
    if not os.path.exists(efs_folder_path):
        os.makedirs(efs_folder_path)

    print("SET PERMISSIONS FOR SAGEMAKER TO SEE FOLDER")

    # Set the permissions of the folder to 777
    os.chmod(efs_folder_path, 0o777)

    print("EFS FOLDER CREATION SUCCESSFUL")

    # Return a successful response
    return {"statusCode": 200, "body": "EFS Folder Creation Successful"}
