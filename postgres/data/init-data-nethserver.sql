-- ----------------------------
-- Update Default settings
-- ---------------------------
UPDATE "core"."settings" SET value = '' WHERE key = 'dropbox.appkey' AND service_id = 'com.sonicle.webtop.core';
UPDATE "core"."settings" SET value = '' WHERE key = 'dropbox.appsecret' AND service_id = 'com.sonicle.webtop.core';
UPDATE "core"."settings" SET value = '' WHERE key = 'googledrive.clientid' AND service_id = 'com.sonicle.webtop.core';
UPDATE "core"."settings" SET value = '' WHERE key = 'googledrive.clientsecret' AND service_id = 'com.sonicle.webtop.core';
UPDATE "core"."settings" SET value = '/usr/share/webtop/bin/' WHERE key = 'php.path' AND service_id = 'com.sonicle.webtop.core';
UPDATE "core"."settings" SET value = '587' WHERE key = 'smtp.port' AND service_id = 'com.sonicle.webtop.core';
UPDATE "core"."settings" SET value = '/tmp' WHERE key = 'zpush.path' AND service_id = 'com.sonicle.webtop.core';

-- --------------------------------
-- Update password for admin users
-- --------------------------------
UPDATE "core"."users" SET secret = '' WHERE user_uid = '991f72dc-2b96-4340-b88f-53506b160519' AND user_id = 'admin';
UPDATE "core"."local_vault" SET password = 'admin';

-- ----------------------------
-- Set default roles
-- ----------------------------
INSERT INTO "core"."users" ("domain_id", "user_id", "type", "enabled", "user_uid", "display_name", "secret") VALUES ('NethServer', 'admins', 'G', 't', '4383a654-633e-4fb6-bf8d-7f197d9c8148', 'Admins', NULL);
INSERT INTO "core"."users" ("domain_id", "user_id", "type", "enabled", "user_uid", "display_name", "secret") VALUES ('NethServer', 'users', 'G', 't', '0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'Users', NULL);

INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.core', 'SERVICE', 'ACCESS', 'com.sonicle.webtop.calendar');
INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.core', 'SERVICE', 'ACCESS', 'com.sonicle.webtop.contacts');
INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.core', 'SERVICE', 'ACCESS', 'com.sonicle.webtop.mail');
INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.core', 'SERVICE', 'ACCESS', 'com.sonicle.webtop.tasks');
INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.core', 'SERVICE', 'ACCESS', 'com.sonicle.webtop.vfs');

INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.core', 'DEVICES_SYNC', 'ACCESS', '*');
INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.core', 'USER_PROFILE_INFO', 'MANAGE', '*');
INSERT INTO "core"."roles_permissions" ("role_uid", "service_id", "key", "action", "instance") VALUES ('0f4d4fa7-7f21-48c0-96c9-fc6d861cc8fe', 'com.sonicle.webtop.mail', 'MAILCARD_SETTINGS', 'CHANGE', '*');

-- -------------------------------------------------------------------
-- Enable synchronization of calendars, contacts and task
-- Supported values: 'O' (disabled), 'R' (read-only), 'W' (read/write)
-- -------------------------------------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.calendar', 'default.calendar.sync', 'W');
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.contacts', 'default.category.sync', 'W');
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.tasks', 'default.category.sync', 'W');

-- -------------------------------------------
-- Hide extra info at the bottom of login page
-- -------------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.core', 'login.systeminfo.hide', 'true');
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.core', 'login.webappname.hide', 'true');

-- -------------------------------------
-- Set download url for dekstop notifier
-- -------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.core', 'addon.notifier.url', 'http://www.nethserver.org/webtop/webtop.exe');

-- -------------------------------------------
-- Disable statistic fields in event window
-- -------------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.calendar', 'event.statistic.fields.visible', 'false');

-- -----------------------------
-- Set Mail grid view to compact
-- -----------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'default.viewmode', 'compact');

-- ---------------------------
-- Enable Mail compact toolbar
-- ---------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'toolbar.compact', 'true');

-- ---------------------------------------------
-- Insert zip media type - HACK for JavaMail bug
-- ---------------------------------------------
INSERT INTO "core"."media_types" ("extension", "media_type") VALUES ('zip', 'application/zip');

-- ---------------------
-- Enable folder sorting
-- ---------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'sort.folders', 'true');

-- -----------------------------------------
-- Always disable built-in SPAM sieve filter
-- -----------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'sieve.spamfilter.disabled', 'true');

-- ---------------------------------------
-- Delete sent messages from draft folders
-- ---------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'default.folder.drafts.deletemsgonsend', 'true');

-- ----------------------
-- Set ACL IMAP lowercase
-- ----------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'imap.acl.lowercase', 'true');

-- ----------------------------------------------------------
-- Set default field to use for ordering contacts to lastname
-- ----------------------------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.contacts', 'default.showby', 'lnfn');

-- ----------------------------------------
-- Set the name for the Jitsi Meet instance
-- ----------------------------------------
DELETE FROM "core"."settings" WHERE service_id = 'com.sonicle.webtop.core' and key = 'meeting.jitsi.name';
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.core', 'meeting.jitsi.name', 'WebTop Meet');

-- ---------------------------------------------------------------------------
-- Prepend username of the creator into the  Jitsi Meet conference room's name
-- ---------------------------------------------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.core', 'meeting.jitsi.meetingid.prependusername', 'true');

-- ------------------------------------------
-- Set default Nextcloud configuration values
-- ------------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.vfs', 'nextcloud.default.host', 'localhost');
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.vfs', 'nextcloud.default.path', '/nextcloud/remote.php/webdav');

-- ------------------------
-- Create vmail user config
-- ------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'nethtop.vmail.secret', '');

-- -----------------------------------------------------------------------
-- Set default remote automatic calendars/contacts synchronization options
-- -----------------------------------------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.calendar', 'calendar.remote.autosync.enabled', 'true');
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.calendar', 'calendar.remote.autosync.onlywhenonline', 'false');
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.contacts', 'category.remote.autosync.enabled', 'true');
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.contacts', 'category.remote.autosync.onlywhenonline', 'false');

-- ---------------------------------
-- Disable known device verification
-- ---------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.core', 'security.knowndeviceverification.enabled', 'false');

-- ------------------------------
-- Set default size icons toolbar
-- ------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.core', 'default.viewport.header.scale', 'medium');

-- ------------------------------
-- Set default locales
-- ------------------------------
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'default.i18n.languageTag', 'en_US');
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'default.i18n.startDay', '0');
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'default.i18n.format.date.short', 'MM/dd/yy');
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'default.i18n.format.date.long', 'MMM dd, yyyy');
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'default.i18n.format.time.short', 'h:mm a');
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'default.i18n.format.time.long', 'h:mm:ss a');

-- ------------------------------
-- Set default timezone
-- ------------------------------
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'default.i18n.timezone', 'Etc/UTC');

-- ------------------------------
-- Disable STARTTLS on local SMTP
-- ------------------------------
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'smtp.auth', 'true');
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.core', 'smtp.starttls', 'false');

-- ------------------------------
-- Set default Spam folder name
-- ------------------------------
DELETE FROM "core"."settings" WHERE service_id = 'com.sonicle.webtop.mail' and key = 'default.folder.spam';
INSERT INTO core.settings (service_id, key, value) VALUES ('com.sonicle.webtop.mail', 'default.folder.spam', 'Junk');

-- -----------------------------------------
-- Strip domain suffix when applying IMAP ACL
-- -----------------------------------------
INSERT INTO "core"."settings" ("service_id", "key", "value") VALUES ('com.sonicle.webtop.mail', 'acl.domainsuffix.policy.override', 'strip');

-- ----------------------------------------
-- Enable PEC Bridge management
-- ----------------------------------------
INSERT INTO "core"."settings" ("service_id","key","value") VALUES ('com.sonicle.webtop.core','config.pecbridge.management','true');

-- ----------------------------------------
-- Set default startup service
-- ----------------------------------------
INSERT INTO "core"."settings" ("service_id","key","value") VALUES ('com.sonicle.webtop.core','default.startup.service','com.sonicle.webtop.mail');

-- ------------------------------------------------------------
-- Set default calendar scheduler time resolution to 15 minutes
-- ------------------------------------------------------------
INSERT INTO "core"."settings" ("service_id","key","value") VALUES ('com.sonicle.webtop.calendar','default.scheduler.timeresolution','15');

-- ----------------
-- Disable WhatsNew
-- ----------------
INSERT INTO core.settings(service_id,key,value) VALUES ('com.sonicle.webtop.core','whatsnew.enabled','false');
