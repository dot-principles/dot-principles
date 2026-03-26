# 12FACTOR-07-PORT-BINDING — Port Binding

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, deployment
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Export services by binding to a port using an embedded server; never rely on external application servers.

## Principle

Export services via port binding. The app is self-contained and exports its HTTP (or other protocol) interface by binding to a port. It does not rely on runtime injection by a web server container; the web server library is a dependency declared in the app's manifest.

## Why it matters

Deploying into an external application server (Tomcat, IIS, WebSphere) couples the app to the container's lifecycle, configuration, and deployment mechanism. Port binding makes the app independently executable as a standalone process, simplifying deployment and enabling one app to become another's backing service.

## Violations to detect

- Applications that require deployment into a running application server (WAR deployed to Tomcat externally managed)
- Web server configuration managed outside the app's codebase and deployment pipeline
- Apps that cannot be started with a single command (`java -jar app.jar`, `node app.js`, `./app`)
- Hardcoded assumptions about which port is available (should come from config/environment)

## Good practice

- Embed the HTTP server as a dependency (Spring Boot's embedded Tomcat, Go's `net/http`, Node's Express)
- Bind the port from an environment variable (`PORT`) so the platform can assign it
- The app starts by running its binary — no external web server setup required

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/port-binding
