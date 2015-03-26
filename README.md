Badgement
================================================================================

Your personal status companion.

[![Stillmaintained](http://stillmaintained.com/Tomohiro/badgement.png)](http://stillmaintained.com/Tomohiro/badgement)


### Heroku Ready

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


Usage
--------------------------------------------------------------------------------

### Post your personal status

Command:

```sh
$ curl http://{your-badge-site}.herokuapp.com/{project}/{branch}/{status-name} \
    -X POST -d "status=passing" -d "color=brightgreen"
```

#### Post parameters

Parameter | Value
--------- | -------------------------------------------------------------------
status    | The status anything you want (e.g. passing, failed, 30%, 85% and so on)
color     | ShieldsIO defined colors (http://shields.io)


#### On Jenkins

Add to "Post build task":

```sh
curl ${BUILD_URL}/api/json?tree=result | grep -q "SUCCESS"

if [ $? -eq 0 ]; then
  curl http://{your-badge-site}.herokuapp.com/{project}/{branch}/{status-name} -X POST -d 'status=passing' -d 'color=brightgreen'
else
  curl http://{your-badge-site}.herokuapp.com/{project}/{branch}/{status-name} -X POST -d 'status=failing' -d 'color=red'
fi
```

### Get saved your personal status

Paste to README at GitHub such as:

```markdown
![My status](https://{your-badge-site.herokuapp.com}/{project}/{branch}/{status-name})
```


LICENSE
--------------------------------------------------------------------------------

&copy; 2012 - 2015 Tomohiro TAIRA.
This project is licensed under the MIT license.
See LICENSE for details.
