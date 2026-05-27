package com.example.app;

import org.junit.jupiter.api.Test;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import static org.assertj.core.api.Assertions.assertThat;

class AppApplicationTest {

    @Test
    void applicationClassIsSpringBootApplication() {
        var annotation = AppApplication.class.getAnnotation(SpringBootApplication.class);

        assertThat(annotation).isNotNull();
    }
}
