package com.example.app.domain.model;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class ProjectIdTest {

    @Test
    void keepsProjectIdValue() {
        var projectId = new ProjectId("project-001");

        assertThat(projectId.value()).isEqualTo("project-001");
    }

    @Test
    void rejectsBlankProjectId() {
        assertThatThrownBy(() -> new ProjectId(" "))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("Project id must not be blank");
    }
}
