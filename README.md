# terraform-ui-module

This is a terraform module to create a static website.

 - [x] support custom domain ( example.com )
 - [x] https for security ( https://example.com )
 - [x] have 'www' subdomain and redirect it to 'https://'
 - [x] CDN configured for speed through CloudFront
 - [x] static assets ( html, css, javascript, images ) hosted on s3
 - [x] ipv4 support
 - [x] ipv6 support
 - [x] all static assets cached on cloudfront except index.html