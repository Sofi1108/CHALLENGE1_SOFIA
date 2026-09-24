17 export AWS_DEFAULT_REGION="us-east-1"
18 aws s3api put-bucket-policy --bucket challenge1-sofia-torcal --policy file://policy.json
19 aws s3api put-public-access-block --bucket challenge1-sofia-torcal --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
20 aws s3api put-bucket-policy --bucket challenge1-sofia-torcal --policy file://policy.json
21 aws s3 sync . s3://challenge1-sofia-torcal/
22 aws s3 sync . s3://challenge1-sofia-torcal/
23 aws s3 sync . s3://challenge1-sofia-torcal/
24 aws s3 website s3://challenge1-sofia-torcal/ --index-document index.html
25 terraform apply
26 erraform apply
27 terraform apply

35 terraform state rm aws_s3_bucket.challenge1_sofia_torcal
36 terraform state list
37 terraform apply
38 terraform state list
39 terraform apply
40 istory
41 history

HAY TAN POCO COMANDO PQ HE REINCIADO EL VS CODE
