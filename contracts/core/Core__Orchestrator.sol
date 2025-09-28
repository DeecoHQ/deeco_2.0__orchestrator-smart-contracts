// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/features-contracts-interfaces/IOrderManagement.sol";
import "../interfaces/features-contracts-interfaces/IAdminManagement.sol";
import "../interfaces/features-contracts-interfaces/IProductManagement.sol";
import "../interfaces/IOrchestratorAdminManagement__Base.sol";
import "../interfaces/IOrchestratorAdminManagement__Core.sol";
import "../Base__Orchestrator.sol";

contract Core__Orchestrator is Base__Orchestrator {
    // -----------------
    // Errors
    // -----------------
    error OrchestratorCore__ZeroAddressError();
    error OrchestratorCore__AccessDenied_AdminOnly();
    error OrchestratorCore__NonMatchingContractAddress();
    error OrchestratorCore__NonMatchingAdminAddress();

    // -----------------
    // State Variables
    // -----------------
    string private constant CONTRACT_NAME = "Core__Orchestrator";

    address private i_owner;

    // -----------------
    // Events
    // -----------------
    event FeatureContractUpdated(
        string feature,
        address oldAddress,
        address newAddress,
        address updatedBy,
        uint256 timestamp
    );

    // -----------------
    // Constructor
    // -----------------
    constructor(address _orchestratorAdminManagementAddress) {
        _verifyIsAddress(_orchestratorAdminManagementAddress);

        s_orchestratorAdminManagementCoreContractAddress = _orchestratorAdminManagementAddress;

        s_orchestratorAdminManagementContract__Base = IOrchestratorAdminManagement__Base(
            _orchestratorAdminManagementAddress
        );

        i_owner = msg.sender;
    }

    // -----------------
    // Internal Helpers
    // -----------------
    function _verifyIsAddress(address _address) internal pure override {
        if (_address == address(0)) revert OrchestratorCore__ZeroAddressError();
    }

    function _verifyIsOrchestratorAdmin(
        address _address
    ) internal view override {
        if (!s_orchestratorAdminManagementContract__Base.checkIsAdmin(_address))
            revert OrchestratorCore__AccessDenied_AdminOnly();
    }

    // -----------------
    // Admin Functions: Update Feature Contracts
    // -----------------
    function updateOrchestratorAdminManagementCoreContractAddress(
        address _newAddress
    ) public {
        _verifyIsOrchestratorAdmin(msg.sender);
        _verifyIsAddress(_newAddress);

        /* 
        updating the admin management core contract address is a very sensitive process. The old/current contract 
        to switch from can be active and working, but if the 'isAdmin' check is passed(on the old/current contract), 
        and a new address is set which is wrong, it becomes impossible to now connect to the intending admin 
        contract. Hence the next step of admin check below, will keep failing and impossible to pass due to contract 
        immutability. Other chores requiring admin check will also be impossible.
    
        Hence the need to first connect and ping to make sure the new contract works before setting
        */
        // first connect and ping
        IOrchestratorAdminManagement__Core s_adminManagementContractToVerify = IOrchestratorAdminManagement__Core(
                _newAddress
            );
        (, address contractAddress, ) = s_adminManagementContractToVerify
            .ping();

        // the fact that it pings without an error is enough - but still do as below to be super-sure
        if (contractAddress != _newAddress) {
            revert OrchestratorCore__NonMatchingAdminAddress();
        }

        /* also ensure current sender is an admin on that contract - which further verifies that the contract 
        is indeed and 'adminManagement' contract */
        if (!s_adminManagementContractToVerify.checkIsAdmin(msg.sender)) {
            revert OrchestratorCore__AccessDenied_AdminOnly();
        }

        s_orchestratorAdminManagementCoreContractAddress = _newAddress;
        s_orchestratorAdminManagementContract__Base = IOrchestratorAdminManagement__Base(
            s_orchestratorAdminManagementCoreContractAddress
        );
    }

    // -----------------
    // View Functions
    // -----------------
    function getContractOwner() external view returns (address) {
        return i_owner;
    }

    function getOrchestratorAdminManagementCoreCOntractAddress()
        external
        view
        returns (address)
    {
        return s_orchestratorAdminManagementCoreContractAddress;
    }

    function getContractName() external pure returns (string memory) {
        return CONTRACT_NAME;
    }

    function ping() external view returns (string memory name, address addr) {
        return (CONTRACT_NAME, address(this));
    }
}
