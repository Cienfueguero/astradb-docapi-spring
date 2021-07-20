package com.example.astradbdocapispring;

import java.io.Console;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
public class AstradbDocapiSpringApplication {

  @Autowired
  private Environment env;

  public static void main(String[] args) {
    SpringApplication.run(AstradbDocapiSpringApplication.class, args);
  }

  @Bean
  public RestTemplate restTemplate(RestTemplateBuilder builder) {
    return builder.build();
  }

  @Bean
  public CommandLineRunner run(RestTemplate restTemplate) throws Exception {
    HttpHeaders headers = new HttpHeaders();
    headers.set("X-Cassandra-Token", env.getProperty("ASTRA_DB_TOKEN"));
	  headers.add("Content-Type","application/JSON");

    HttpEntity<String> httpEntity = new HttpEntity<String>(headers);

    return args -> {
	  Console console = System.console();
	  String docId = console.readLine("Enter the document ID: ");

      ResponseEntity<Persons> persons = restTemplate.exchange(
        "https://" +
        env.getProperty("ASTRA_DB_ID") +
        "-" +
        env.getProperty("ASTRA_DB_REGION") +
        ".apps.astra.datastax.com/api/rest/v2/namespaces/" +
        env.getProperty("ASTRA_DB_KEYSPACE") +
        "/collections/persons/" +
		docId,
        HttpMethod.GET,
        httpEntity,
        Persons.class
      );
	  console.printf("Document ID: " + docId + 
	  " is about an architect called: " + persons.getBody());
    };
  }
}