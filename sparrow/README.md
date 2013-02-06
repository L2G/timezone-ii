Sparrow Cookbook
================
This sets up Sparrow for use as a server.  All parts of the Ruby gem are
installed, so it can also be used as a client.

Requirements
------------

#### Cookbooks
- `sqlite` - Sparrow depends on the SQLite library

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### sparrow::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sparrow']['pid_path']</tt></td>
    <td>String</td>
    <td>Directory to use for Sparrow server to save PIDs. At present, this is
    used only to create the directory.</td>
    <td><tt>/var/run/sparrow/pids</tt></td>
  </tr>
  <tr>
    <td><tt>['sparrow']['spool_path']</tt></td>
    <td>String</td>
    <td>Directory to use for Sparrow's message queue. At present, this is used
    only to create the directory.</td>
    <td><tt>/var/spool/sparrow/base</tt></td>
  </tr>
</table>

Usage
-----
#### sparrow::default

Just include `sparrow` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sparrow]"
  ]
}
```

Directories specified in the attributes will be created. Since there is no
helper script included with this cookbook, you must start the server yourself
and use the appropriate command-line options if you set paths different from the
defaults.

Contributing
------------
1. Fork the repository on GitHub
2. Create a named feature branch (like `add\_component\_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a pull request using GitHub

License and Authors
-------------------
Authors: Lawrence Leonard Gilbert <larry@L2G.to>

This cookbook may be distributed under the same terms as Chef (i.e., the Apache
2.0 license).
