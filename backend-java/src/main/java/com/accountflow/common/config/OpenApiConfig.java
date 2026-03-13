package com.accountflow.common.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

  @Bean
  public OpenAPI accountFlowOpenApi() {
    return new OpenAPI()
        .info(new Info()
            .title("AccountFlow Core API")
            .description("Banking-style demo API for accounts, payments, transactions, reports, and audit logs")
            .version("v1")
            .contact(new Contact().name("AccountFlow Team").email("team@accountflow.demo"))
            .license(new License().name("Demo License")));
  }
}
