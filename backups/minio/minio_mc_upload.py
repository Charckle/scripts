import sys

# file_uploader.py MinIO Python SDK example
from minio import Minio
from minio.error import S3Error

file_name_ = "test_.md"
file_pwd_ = "/path/to/file"
file_w_loc = f"{file_pwd_}/{file_name_}"

# The destination bucket and filename on the MinIO server
bucket_name = "mybucket"
destination_file = f"subfolder/{file_name_}"

def main():
    # Create a client with the MinIO server playground, its access key
    # and secret key.
    
    # Parse command-line arguments
    var1 = str(sys.argv[1]) #access key
    var2 = str(sys.argv[2]) # secret key
    
    client = Minio("box02.razor.si",
        #access_key='Os7oGkFDUvFRQG7BxjeZ',
        #secret_key='BQu2pfaLNMk6fxgbEABfi9X7fJYr04xateJWT7my',
        access_key=var1,
        secret_key=var2,
        region='si', #required, though the documentation say its not. minio does not check it, so it can be anything
        #secure=False
        cert_check=False
    )
    
    # The file to upload, change this path if needed
    source_file = file_w_loc

    
    # Make the bucket if it doesn't exist.
    found = client.bucket_exists(bucket_name)
    
    if not found:
        print(f"bucket does not exits: {bucket_name}")
    else:
        print("Bucket", bucket_name, "already exists")

    # Upload the file, renaming it in the process
    client.fput_object(
        bucket_name, destination_file, source_file,
    )
    print(
        source_file, "successfully uploaded as object",
        destination_file, "to bucket", bucket_name,
    )

if __name__ == "__main__":
    # Check if two arguments are provided
    if len(sys.argv) != 3:
        print("Usage: python script.py access_key secret_key")
        quit()    
    try:
        main()
    except S3Error as exc:
        print("error occurred.", exc)
