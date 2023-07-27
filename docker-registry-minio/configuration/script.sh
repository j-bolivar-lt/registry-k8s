mc alias set myminio http://localhost:9000 admin 8ysoB55UBj

# Create bucket named docker-bucket
mc mb myminio/docker-bucket

# Add a username name generic-user that only has access to the docker-bucket bucket
mc admin user add myminio generic-user generic-password

mc admin policy create myminio dockerBucketPolicy docker-bucket-policy.json

mc admin policy attach myminio dockerBucketPolicy --user generic-user

