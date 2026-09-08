-- init.sql — security_events 테이블 생성
-- board_server(= 이 폴더의 app.py, SQLAlchemy db.create_all() 로 이미 자동 생성됨)와
-- 동일한 스키마를 raw SQL 로도 남겨 둔다 (수동 생성/과제 제출용).
--
-- 실행: mysql -u root -p board_db < init.sql
-- 접속 정보는 .env 의 DATABASE_URL 을 따른다.

CREATE DATABASE IF NOT EXISTS board_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE board_db;

CREATE TABLE IF NOT EXISTS security_events (
  id           INT NOT NULL AUTO_INCREMENT,
  student      VARCHAR(50)  NOT NULL,           -- 본인 식별자
  src_ip       VARCHAR(45)  NOT NULL,           -- IPv6 까지 담도록 45자
  fail_count   INT          NOT NULL DEFAULT 0,
  decision     VARCHAR(10)  NOT NULL,           -- allow | deny
  severity     VARCHAR(10)  NOT NULL DEFAULT 'Low',
  reason       VARCHAR(200) DEFAULT NULL,
  users        VARCHAR(255) DEFAULT NULL,
  last_seen    VARCHAR(32)  DEFAULT NULL,
  window_min   INT          DEFAULT NULL,
  source       VARCHAR(50)  DEFAULT 'login_guard',
  generated_at VARCHAR(32)  DEFAULT NULL,
  created_at   DATETIME     DEFAULT NULL,
  PRIMARY KEY (id),
  KEY ix_security_events_student (student),
  KEY ix_security_events_src_ip (src_ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
