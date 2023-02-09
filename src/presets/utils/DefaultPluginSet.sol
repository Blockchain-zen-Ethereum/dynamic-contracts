// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

// Interface
import "../../interface/IDefaultPluginSet.sol";

// Extensions
import "./PluginState.sol";

contract DefaultPluginSet is IDefaultPluginSet, PluginState {
    using StringSet for StringSet.Set;

    /*///////////////////////////////////////////////////////////////
                            State variables
    //////////////////////////////////////////////////////////////*/

    /// @notice The deployer of DefaultPluginSet.
    address private deployer;

    /*///////////////////////////////////////////////////////////////
                            Constructor
    //////////////////////////////////////////////////////////////*/

    constructor() {
        deployer = msg.sender;
    }

    /*///////////////////////////////////////////////////////////////
                            External functions
    //////////////////////////////////////////////////////////////*/

    /// @notice Stores a plugin in the DefaultPluginSet.
    function setPlugin(Plugin memory _plugin) external {
        require(msg.sender == deployer, "DefaultPluginSet: unauthorized caller.");
        _addPlugin(_plugin);
    }

    /*///////////////////////////////////////////////////////////////
                            View functions
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns all plugins stored.
    function getAllPlugins() external view returns (Plugin[] memory allPlugins) {
        PluginStateStorage.Data storage data = PluginStateStorage.pluginStateStorage();

        string[] memory names = data.pluginNames.values();
        uint256 len = names.length;

        allPlugins = new Plugin[](len);

        for (uint256 i = 0; i < len; i += 1) {
            allPlugins[i] = data.plugins[names[i]];
        }
    }

    /// @notice Returns the plugin metadata and functions for a given plugin.
    function getPlugin(string memory _pluginName) public view returns (Plugin memory) {
        PluginStateStorage.Data storage data = PluginStateStorage.pluginStateStorage();
        require(data.pluginNames.contains(_pluginName), "DefaultPluginSet: plugin does not exist.");
        return data.plugins[_pluginName];
    }

    /// @notice Returns the plugin's implementation smart contract address.
    function getPluginImplementation(string memory _pluginName) external view returns (address) {
        return getPlugin(_pluginName).metadata.implementation;
    }

    /// @notice Returns all functions that belong to the given plugin contract.
    function getAllFunctionsOfPlugin(string memory _pluginName) external view returns (PluginFunction[] memory) {
        return getPlugin(_pluginName).functions;
    }

    /// @notice Returns the plugin metadata for a given function.
    function getPluginForFunction(bytes4 _functionSelector) external view returns (PluginMetadata memory) {
        PluginStateStorage.Data storage data = PluginStateStorage.pluginStateStorage();
        PluginMetadata memory metadata = data.pluginMetadata[_functionSelector];
        require(metadata.implementation != address(0), "DefaultPluginSet: no plugin for function.");
        return metadata;
    }
}