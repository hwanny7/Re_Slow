package com.ssafy.reslow.infra.storage;

import java.io.IOException;
import java.util.UUID;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class S3StorageClient implements StorageClient {

	private AmazonS3 s3Client;

	@Value("${cloud.aws.credentials.accessKey}")
	private String accessKey;

	@Value("${cloud.aws.credentials.secretKey}")
	private String secretKey;

	@Value("${cloud.aws.s3.bucket}")
	private String bucket;

	@Value("${cloud.aws.region.static}")
	private String region;

	@PostConstruct
	public void setS3Client() {
		AWSCredentials credentials = new BasicAWSCredentials(this.accessKey, this.secretKey);

		s3Client = AmazonS3ClientBuilder.standard()
			.withCredentials(new AWSStaticCredentialsProvider(credentials))
			.withRegion(this.region)
			.build();
	}

	@Override
	public String uploadFile(MultipartFile file) throws IOException {
		if (file != null && !file.isEmpty()) {
			String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename()
				.replaceAll("[~!@#$%^&*()_+ ]", "_");
			s3Client.putObject(new PutObjectRequest(bucket, fileName, file.getInputStream(), null)
				.withCannedAcl(CannedAccessControlList.PublicRead));
			return s3Client.getUrl(bucket, fileName).toString();
		} else {
			return null;
		}
	}

	@Override
	public void deleteFile(String fileUrl) {
		try {
			String key = fileUrl;
			if (fileUrl == null) {
				return;
			}
			s3Client.deleteObject(bucket, (key).substring(54));
		} catch (AmazonServiceException e) {
			log.error(e.getErrorMessage());
			System.exit(1);
		}
	}
}
