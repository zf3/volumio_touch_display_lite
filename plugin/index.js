'use strict';

const libQ = require('kew');
const id = 'touch_display_lite: ';
const blInterface = '/sys/devices/platform/rpi_backlight/backlight/rpi_backlight';

module.exports = TouchDisplayLite;

function TouchDisplayLite (context) {

	const self = this;

    self.context = context;
    self.commandRouter = self.context.coreCommand;
    self.logger = self.context.logger;
    self.configManager = self.context.configManager;    
}

TouchDisplayLite.prototype.onStart = function() {
    const self = this;
    const defer = libQ.defer();
    self.commandRouter.loadI18nStrings();
    self.systemctl('daemon-reload')
      .then(self.systemctl.bind(self, 'start touch_display_lite.service'))
      .then(function () {
        self.logger.info(id + "Touch Display Lite started.");
        defer.resolve();
      })
      .fail(function() {
         defer.reject(new Error());
       });
    return defer.promise;
}

TouchDisplayLite.prototype.onStop = function () {
  const self = this;
  const defer = libQ.defer();
  self.systemctl('stop touch_display_lite.service')
    .fin(function () {
      defer.resolve();
    });
  return defer.promise;
}

TouchDisplayLite.prototype.systemctl = function (systemctlCmd) {
    const self = this;
    const defer = libQ.defer();
  
    exec('/usr/bin/sudo /bin/systemctl ' + systemctlCmd, { uid: 1000, gid: 1000 }, function (error, stdout, stderr) {
      if (error !== null) {
        self.logger.error(id + 'Failed to ' + systemctlCmd + ': ' + error);
        self.commandRouter.pushToastMessage('error', self.commandRouter.getI18nString('TOUCH_DISPLAY_LITE.PLUGIN_NAME'), self.commandRouter.getI18nString('TOUCH_DISPLAY_LITE.GENERIC_FAILED') + systemctlCmd + ': ' + error);
        defer.reject(error);
      } else {
        self.logger.info(id + 'systemctl ' + systemctlCmd + ' succeeded.');
        defer.resolve();
      }
    });
    return defer.promise;
  };
