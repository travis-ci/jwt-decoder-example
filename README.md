# jwt-decoder-example

This small Sinatra application shows how a third-party service may support
Travis CI's JWT addon.

## Background

On Travis CI, repository owners can use secure environment variables to
use sensitive information (such as AWS S3 credentials, Heroku API keys).
They are not avaialble to Pull Requests because a malicious actor can
simply `echo` sensitive data to the build log.

If the secret is for use by a third-party, the third-party can implement
a service that incorporates the `jwt` addon.

### How does `jwt` addon share the secret without divulging it to PR authors (who are potentially malicious)?

The third-party and the repository owners share a secret. The pull request
authors do not know this secret.

The `jwt` addon will sign the payload (containing a few pieces of information
about the build; they can be decoded, so there is no sensitive information in
it) with the secret shared by the third-party and the repository owners.

Inside the build script, the repository owner's secret is replaced by the JWT
token by the addon.

The PR author can access the JWT token thus signed, but they cannot verify the
signature, because they do not have the knowledge of the secret.

The third-party service will have the Travis CI build send the token (either
by an addon to `travis-build`, or by instructing the user of the service to add custom
steps). The service then uses the shared secret to verify the signature, and
provide service to the user based on the JWT payload (and other payload the
user may have sent).

## Using this app

### Starting the app locally

```sh-session
$ bundle install
$ env JWT_SECRET=super_duper bundle exec je puma -I lib

```

### POST a request

```sh-session
$ curl -X POST -H "Content-Type: application/json" http://localhost:9292/decode -d '{ "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJUcmF2aXMgQ0ksIEdtYkgiLCJzbHVnIjoiQmFuemFpTWFuL2p3dC1kZWNvZGVyLWV4YW1wbGUiLCJwdWxsLXJlcXVlc3QiOiIiLCJpYXQiOjE0NzEyMjEzNzUsImV4cCI6MTUwMDAwMDAwMH0.inAc-WwJBMcP3GR-2uXM30Y_osBdw_3Dgw6UNbdi93o" }'
```