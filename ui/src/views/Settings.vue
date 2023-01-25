<!--
  Copyright (C) 2022 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getConfiguration">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-configuration')"
          :description="error.getConfiguration"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-form @submit.prevent="configureModule">
            <cv-text-input
              :label="$t('settings.webtop_fqdn')"
              placeholder="webtop.example.org"
              v-model.trim="hostname"
              class="mg-bottom"
              :invalid-message="$t(error.hostname)"
              :disabled="loading.getConfiguration || loading.configureModule"
              ref="hostname"
            >
            </cv-text-input>
            <cv-toggle
              value="letsEncrypt"
              :label="$t('settings.request_https_certificate')"
              v-model="isLetsEncryptEnabled"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="mg-bottom"
            >
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </cv-toggle>
            <NsComboBox
              v-model.trim="mail_module"
              :autoFilter="true"
              :autoHighlight="true"
              :title="$t('settings.mail_server_fqdn')"
              :label="$t('settings.choose_mail_server')"
              :options="mail_module_widget"
              :userInputLabel="core.$t('settings.choose_mail_server')"
              :acceptUserInput="false"
              :showItemType="true"
              :invalid-message="$t(error.mail_module)"
              :disabled="loading.getConfiguration || loading.configureModule"
              tooltipAlignment="start"
              tooltipDirection="top"
              ref="mail_module"
            >
              <template slot="tooltip">
              {{
                $t("settings.choose_the_mail_server_to_use")
              }}
              </template>
            </NsComboBox>
            <cv-dropdown 
              :value="locale"
              class="maxwidth"
              v-model="locale"
              :up="false"
              :inline="false"
              :helper-text="$t('settings.default_locale_for_webtop_users')"
              :hide-selected="false"
              :invalid-message="$t(error.locale)"
              :label="$t('settings.select_locale')"
              :disabled="loading.getConfiguration || loading.configureModule">
              <cv-dropdown-item  value="it_IT">{{$t('settings.LOCALE_it_IT')}}</cv-dropdown-item>
              <cv-dropdown-item  selected value="en_US">{{$t('settings.LOCALE_en_US')}}</cv-dropdown-item>
              <cv-dropdown-item  value="de_DE">{{$t('settings.LOCALE_de_DE')}}</cv-dropdown-item>
              <cv-dropdown-item  value="es_ES">{{$t('settings.LOCALE_es_ES')}}</cv-dropdown-item>
              <cv-dropdown-item  value="hr_HR">{{$t('settings.LOCALE_hr_HR')}}</cv-dropdown-item>
              <cv-dropdown-item  value="hu_HU">{{$t('settings.LOCALE_hu_HU')}}</cv-dropdown-item>
              <cv-dropdown-item  value="fr_FR">{{$t('settings.LOCALE_fr_FR')}}</cv-dropdown-item>
            </cv-dropdown>
            <NsComboBox
              v-model.trim="timezone"
              :autoFilter="true"
              :autoHighlight="true"
              :title="$t('settings.timezone')"
              :label="$t('settings.choose_timezone')"
              :options="accepted_timezone_list"
              :userInputLabel="core.$t('settings.choose_timezone')"
              :acceptUserInput="false"
              :showItemType="true"
              :invalid-message="$t(error.accepted_timezone_list)"
              :disabled="loading.getConfiguration || loading.configureModule"
              tooltipAlignment="start"
              tooltipDirection="top"
              ref="accepted_timezone_list"
              :helper-text="$t('settings.default_timezone_for_webtop_users')"
            >
            </NsComboBox>
            <!-- advanced options -->
            <cv-accordion ref="accordion" class="maxwidth mg-bottom">
              <cv-accordion-item :open="toggleAccordion[0]">
                <template slot="title">{{ $t("settings.advanced") }}</template>
                <template slot="content">
                  <cv-toggle
                    value="webapp_debug"
                    :label="$t('settings.webapp_debug')"
                    v-model="webapp.debug"
                    :disabled="loading.getConfiguration || loading.configureModule"
                    class="mg-bottom"
                  >
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </cv-toggle>
                  <cv-number-input
                    :label="$t('settings.min_webapp_memory')"
                    :invalid-message="$t(error.webapp.min_memory)"
                    :helper-text="$t('settings.choose_min_webapp_memory_MB')"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    v-model.trim="webapp.min_memory"
                    :min="512"
                    :max="webapp.max_memory"
                    :step="1"
                    :mobile="false"
                    ref="min_memory"
                    >
                  </cv-number-input>
                  <cv-number-input
                    :label="$t('settings.max_webapp_memory')"
                    :invalid-message="$t(error.webapp.max_memory)"
                    :helper-text="$t('settings.choose_max_webapp_memory_MB')"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    v-model.trim="webapp.max_memory"
                    :min="webapp.min_memory"
                    :max="4096"
                    :step="1"
                    :mobile="false"
                    ref="max_memory"
                    >
                  </cv-number-input>
                  <cv-toggle
                    value="webdav_debug"
                    :label="$t('settings.webdav_debug')"
                    v-model="webdav.debug"
                    :disabled="loading.getConfiguration || loading.configureModule"
                    class="mg-bottom"
                  >
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </cv-toggle>
                  <cv-dropdown 
                    :value="webdav.loglevel"
                    v-model="webdav.loglevel"
                    :up="false"
                    :inline="false"
                    :helper-text="$t('settings.debug_loglevel')"
                    :hide-selected="false"
                    :invalid-message="$t(error.webdav.loglevel)"
                    :label="$t('settings.select_webdav_loglevel')"
                    :disabled="loading.getConfiguration || loading.configureModule">
                    <cv-dropdown-item value="ALERT">{{$t('settings.LOG_ALERT')}}</cv-dropdown-item>
                    <cv-dropdown-item value="CRITICAL">{{$t('settings.LOG_CRITICAL')}}</cv-dropdown-item>
                    <cv-dropdown-item value="DEBUG">{{$t('settings.LOG_DEBUG')}}</cv-dropdown-item>
                    <cv-dropdown-item value="EMERGENCY">{{$t('settings.LOG_EMERGENCY')}}</cv-dropdown-item>
                    <cv-dropdown-item selected value="ERROR">{{$t('settings.LOG_ERROR')}}</cv-dropdown-item>
                    <cv-dropdown-item value="INFO">{{$t('settings.LOG_INFO')}}</cv-dropdown-item>
                    <cv-dropdown-item value="NOTICE">{{$t('settings.LOG_NOTICE')}}</cv-dropdown-item>
                    <cv-dropdown-item value="WARNING">{{$t('settings.LOG_WARNING')}}</cv-dropdown-item>
                  </cv-dropdown>
                  <cv-dropdown 
                    :value="zpush.loglevel"
                    v-model="zpush.loglevel"
                    :up="false"
                    :inline="false"
                    :helper-text="$t('settings.debug_loglevel')"
                    :hide-selected="false"
                    :invalid-message="$t(error.zpush.loglevel)"
                    :label="$t('settings.select_zpush_loglevel')"
                    :disabled="loading.getConfiguration || loading.configureModule">
                    <cv-dropdown-item  value="ALERT">{{$t('settings.LOG_ALERT')}}</cv-dropdown-item>
                    <cv-dropdown-item  value="CRITICAL">{{$t('settings.LOG_CRITICAL')}}</cv-dropdown-item>
                    <cv-dropdown-item  value="DEBUG">{{$t('settings.LOG_DEBUG')}}</cv-dropdown-item>
                    <cv-dropdown-item  value="EMERGENCY">{{$t('settings.LOG_EMERGENCY')}}</cv-dropdown-item>
                    <cv-dropdown-item selected value="ERROR">{{$t('settings.LOG_ERROR')}}</cv-dropdown-item>
                    <cv-dropdown-item  value="INFO">{{$t('settings.LOG_INFO')}}</cv-dropdown-item>
                    <cv-dropdown-item  value="NOTICE">{{$t('settings.LOG_NOTICE')}}</cv-dropdown-item>
                    <cv-dropdown-item  value="WARNING">{{$t('settings.LOG_WARNING')}}</cv-dropdown-item>
                  </cv-dropdown>
                </template>
              </cv-accordion-item>
            </cv-accordion>
            <cv-row v-if="error.configureModule">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.configure-module')"
                  :description="error.configureModule"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <NsButton
              kind="primary"
              :icon="Save20"
              :loading="loading.configureModule"
              :disabled="loading.getConfiguration || loading.configureModule"
              >{{ $t("settings.save") }}</NsButton
            >
          </cv-form>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import to from "await-to-js";
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";

export default {
  name: "Settings",
  mixins: [
    TaskService,
    IconService,
    UtilService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settings",
      },
      urlCheckInterval: null,
      hostname: "",
      isLetsEncryptEnabled: false,
      mail_module: "",
      mail_module_widget: [],
      accepted_timezone_list: [],
      locale: "it_IT",
      timezone: "Europe/Rome",
      webapp: {
        min_memory: 512,
        max_memory: 1024,
        debug: false
      },
      webdav: {
        loglevel: "ERROR",
        debug: false
      },
      zpush: {
        loglevel: "ERROR",
      },
      loading: {
        getConfiguration: false,
        configureModule: false,
      },
      error: {
        getConfiguration: "",
        configureModule: "",
        hostname: "",
        request_https_certificate: "",
        mail_module: "",
        locale: "",
        timezone:"",
        webapp: {
          min_memory: "",
          max_memory: "",
          debug: false
        },
        webdav: {
          loglevel: "",
          debug: false
        },
        zpush: {
          loglevel: "",
        },
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
  },
  created() {
    this.getConfiguration();
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  methods: {
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getConfigurationAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getConfigurationCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.getConfiguration = this.getErrorMessage(err);
        this.loading.getConfiguration = false;
        return;
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      const config = taskResult.output;
      this.hostname = config.hostname;
      this.isLetsEncryptEnabled = config.request_https_certificate;
      this.upload_max_filesize = config.upload_max_filesize;
      this.webapp = config.webapp;
      this.webdav = config.webdav;
      this.zpush = config.zpush;
      this.mail_module_widget = config.mail_module_widget;
      this.accepted_timezone_list = config.accepted_timezone_list;
      // force to reload value after dom update
      this.$nextTick(() => {
        this.mail_module = config.mail_module;
        this.timezone = config.timezone;
      });
      this.loading.getConfiguration = false;
      this.focusElement("hostname");
    },
    validateConfigureModule() {
      this.clearErrors(this);

      let isValidationOk = true;
      if (!this.hostname) {
        this.error.hostname = "common.required";

        if (isValidationOk) {
          this.focusElement("hostname");
        }
        isValidationOk = false;
      }
      if (!this.mail_module) {
        this.error.mail_module = "common.required";

        if (isValidationOk) {
          this.focusElement("mail_module");
        }
        isValidationOk = false;
      }
      return isValidationOk;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        // set i18n error message
        this.error[param] = this.$t("settings." + validationError.error);

        if (!focusAlreadySet) {
          this.focusElement(param);
          focusAlreadySet = true;
        }
      }
    },
    async configureModule() {
      const isValidationOk = this.validateConfigureModule();
      if (!isValidationOk) {
        return;
      }

      this.loading.configureModule = true;
      const taskAction = "configure-module";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.configureModuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.configureModuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.configureModuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            hostname: this.hostname,
            request_https_certificate: this.isLetsEncryptEnabled,
            mail_module: this.mail_module,
            locale: this.locale,
            timezone: this.timezone,
            webapp: {
              min_memory: parseInt(this.webapp.min_memory),
              max_memory: parseInt(this.webapp.max_memory),
              debug: this.webapp.debug
            },
            webdav: {
              loglevel: this.webdav.loglevel,
              debug: this.webdav.debug
            },
            zpush: {
              loglevel: this.zpush.loglevel,
            },
          },
          extra: {
            title: this.$t("settings.instance_configuration", {
              instance: this.instanceName,
            }),
            description: this.$t("settings.configuring"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
        return;
      }
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.configureModule = this.$t("error.generic_error");
      this.loading.configureModule = false;
    },
    configureModuleCompleted() {
      this.loading.configureModule = false;

      // reload configuration
      this.getConfiguration();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
.mg-bottom {
  margin-bottom: $spacing-06;
}

.maxwidth {
  max-width: 38rem;
}
</style>
