# NSO MCP Tools command

This repository provides an extension for Cisco NSO to add the `show mcp-tools advertised` command. This command allows you to list all tools currently advertised via the MCP (Model Context Protocol) interface directly from the NSO CLI.

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/hitakaha/nso-show-mcp-tools-advertised.git
   cd nso-show-mcp-tools-advertised/src

2. Execute following in src folder
   ```bash
   make install

4. Load the package
   ```
   admin@ncs# packages reload

## Usage
To view the advertised MCP tools, run the following command in the NSO CLI:

```
admin@ncs# show mcp-tools advertised
result 
--------------------------------------------------------------------------------
Advertised MCP Tools (Detailed View)
--------------------------------------------------------------------------------
Tool Index:   1
Tool Name:    echo
Description: Echo back a message with user context (sample tool)
--------------------------------------------------------------------------------
Tool Index:   2
Tool Name:    tfnm_ncs_state_patches_load_modules
Description: NSO Action: load-modules (path: 
             /tfnm:ncs-state/patches/load-modules)
--------------------------------------------------------------------------------
Tool Index:   3
Tool Name:    tfnm_ncs_state_set_read_only
Description: NSO Action: set-read-only (path: 
             /tfnm:ncs-state/set-read-only)
--------------------------------------------------------------------------------
```
