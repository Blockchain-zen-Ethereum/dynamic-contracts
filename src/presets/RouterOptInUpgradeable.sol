// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./TWRouter.sol";
import "./PluginRegistry.sol";

import "@thirdweb-dev/contracts/extension/PermissionsEnumerable.sol";

contract RouterOptInUpgradeable is TWRouter, PermissionsEnumerable {
    /*///////////////////////////////////////////////////////////////
                            State variables
    //////////////////////////////////////////////////////////////*/

    bytes32 public constant PLUGIN_ADMIN_ROLE = keccak256("PLUGIN_ADMIN_ROLE");

    /*///////////////////////////////////////////////////////////////
                            Constructor
    //////////////////////////////////////////////////////////////*/

    constructor(
        address _pluginAdmin,
        address _pluginRegistry,
        string[] memory _pluginNames
    ) TWRouter(_pluginRegistry, _pluginNames) {
        _setupRole(PLUGIN_ADMIN_ROLE, _pluginAdmin);
        _setRoleAdmin(PLUGIN_ADMIN_ROLE, PLUGIN_ADMIN_ROLE);
    }

    /*///////////////////////////////////////////////////////////////
                        Internal functions
    //////////////////////////////////////////////////////////////*/

    /// @dev Returns whether plug-in can be set in the given execution context.
    function _canSetPlugin() internal view virtual override returns (bool) {
        return hasRole(PLUGIN_ADMIN_ROLE, msg.sender);
    }
}
