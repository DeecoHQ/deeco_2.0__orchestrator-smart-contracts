// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/features-contracts-interfaces/IOrderManagement.sol";
import "./interfaces/features-contracts-interfaces/IAdminManagement.sol";
import "./interfaces/features-contracts-interfaces/IProductManagement.sol";
import "./interfaces/IOrchestratorAdminManagement__Base.sol";

contract Base__Orchestrator {
    // -----------------
    // Custom Errors
    // -----------------
    error Orchestrator__ZeroAddressError();
    error Orchestrator__AccessDenied_AdminOnly();

    // -----------------
    // State variables
    // -----------------
    address internal s_featuresAdminManagementCoreContractAddress;
    address internal s_orchestratorAdminManagementCoreContractAddress;
    address internal s_productManagementCoreContractAddress;
    address internal s_orderManagementCoreContractAddress;

    IOrchestratorAdminManagement__Base
        internal s_orchestratorAdminManagementContract__Base =
        IOrchestratorAdminManagement__Base(
            s_orchestratorAdminManagementCoreContractAddress
        );

    IAdminManagement internal s_adminManagementContract =
        IAdminManagement(s_featuresAdminManagementCoreContractAddress);

    IProductManagement internal s_productManagementContract =
        IProductManagement(s_productManagementCoreContractAddress);

    IOrderManagement internal s_orderManagementContract =
        IOrderManagement(s_orderManagementCoreContractAddress);

    // -----------------
    // Internal helpers
    // -----------------
    function _verifyIsAddress(address _address) internal pure virtual {
        if (_address == address(0)) {
            revert Orchestrator__ZeroAddressError();
        }
    }

    function _verifyIsOrchestratorAdmin(
        address _address
    ) internal view virtual {
        if (
            !s_orchestratorAdminManagementContract__Base.checkIsAdmin(_address)
        ) {
            revert Orchestrator__AccessDenied_AdminOnly();
        }
    }

    /* 
    for all orchestration tasks, you must first activate each contract with its live address before calling it
    else the call will be empty since the contracts are yet to be acitivated with live addresses.
    
    Why don't we activate the feature contracts using a constructor?

    Because we will be orchestrating for multiple stores with different feature contract addresses. Hence we 
    can't activate only a single one. Same patterns for all orchestrations - activate and use.
    */
    function handleProcessOrder__ERC20(
        address _createdBy,
        string memory _orderCID,
        uint256 _totalAmount,
        address _orderFeaturesContractAddressForStore
    ) public {
        _verifyIsOrchestratorAdmin(msg.sender);

        // activate the feature contract
        s_orderManagementCoreContractAddress = _orderFeaturesContractAddressForStore;

        s_orderManagementContract = IOrderManagement(
            s_orderManagementCoreContractAddress
        );

        s_orderManagementContract.processOrder__ERC20(
            _createdBy,
            _orderCID,
            _totalAmount
        );
    }

    // continue with other ochestration(backend needing) chores. Stopping here for the Soonami hackathon
}
