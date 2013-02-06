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
    <td><tt>['sparrow']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### sparrow::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `sparrow` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sparrow]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Lawrence Leonard Gilbert <larry@L2G.to>

This cookbook may be distributed under the same terms as Chef (i.e., the Apache
2.0 license).
