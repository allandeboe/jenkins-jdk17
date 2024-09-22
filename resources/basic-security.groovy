#!groovy

import jenkins.model.*
import hudson.security.*

import io.jenkins.plugins.thememanager.*
import io.jenkins.plugins.darktheme.*

////////////////////////////////////////////////////////////////////////////////

def jenkins = Jenkins.getInstance()

println "--> setting number of executors for built-in node to 0"
jenkins.setNumExecutors(0)

println "--> creating local user 'admin-jenkins'"
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','admin')
jenkins.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
jenkins.setAuthorizationStrategy(strategy)

///////////////////////////////////////////////////////////////////////////////

// How is changing the theme considered security? Well, it will secure
// your retnas from the threat agent that is light.
println "--> setting theme to dark"
def themeDecorator = jenkins.getExtensionList(ThemeManagerPageDecorator.class).first()
themeDecorator.setTheme(new DarkThemeManagerFactory())
themeDecorator.save()

///////////////////////////////////////////////////////////////////////////////

jenkins.save()