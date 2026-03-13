package com.accountflow.audit.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "audit_logs")
public class AuditLog {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "actor_user_id")
  private Long actorUserId;
  @Column(name = "action_type", nullable = false)
  private String actionType;
  @Column(name = "entity_type", nullable = false)
  private String entityType;
  @Column(name = "entity_id")
  private String entityId;
  @Column(name = "details_json")
  private String detailsJson;
  @Column(name = "created_at")
  private OffsetDateTime createdAt;

  public Long getId() { return id; }
  public Long getActorUserId() { return actorUserId; }
  public void setActorUserId(Long actorUserId) { this.actorUserId = actorUserId; }
  public String getActionType() { return actionType; }
  public void setActionType(String actionType) { this.actionType = actionType; }
  public String getEntityType() { return entityType; }
  public void setEntityType(String entityType) { this.entityType = entityType; }
  public String getEntityId() { return entityId; }
  public void setEntityId(String entityId) { this.entityId = entityId; }
  public String getDetailsJson() { return detailsJson; }
  public void setDetailsJson(String detailsJson) { this.detailsJson = detailsJson; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }
}
