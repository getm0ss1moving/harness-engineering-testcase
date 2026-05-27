package com.example.app.domain.model;

/**
 * Stable identifier for a project aggregate.
 */
public record ProjectId(String value) {

    public ProjectId {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Project id must not be blank");
        }
    }
}
