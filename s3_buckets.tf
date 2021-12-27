
resource "aws_s3_bucket" "s3_static_website" {
  bucket = "${var.s3_bucket_name}"
  acl    = "public-read"
  force_destroy = true
  policy = <<POLICY
    {
			"Version": "2012-10-17",
			"Statement": [
				{
					"Sid": "PublicReadGetObject",
					"Effect": "Allow",
					"Principal": "*",
					"Action": [
							"s3:GetObject"
					],
					"Resource": [
							"arn:aws:s3:::${var.s3_bucket_name}/*"
					]
        }
    	]
		}
  POLICY
  website {
    index_document = "index.html"
  }

	 tags = {
    DEV_EXAM        = "Alfredo Vazquez Maldonado"
  }
}


resource "aws_s3_bucket" "blob_bucket_for_workexam" {
  bucket = "${var.myblobbucketforexam}"
  acl    = "private"
  force_destroy = true
  tags = {
    DEV_EXAM        = "Alfredo Vazquez Maldonado"
  }
}

resource "aws_s3_bucket_object" "folder1" {
    bucket = "${aws_s3_bucket.blob_bucket_for_workexam.id}"
    acl    = "private"
    key    = "images/"
    source = "/dev/null"
}



