// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

/// @notice Combined interface for Core__OrderManagement and its inherited contracts
interface IOrderManagement {
    // ------------------------
    // Structs
    // ------------------------
    struct Order {
        uint256 orderId;
        address createdBy;
        string orderCID;
        uint256 totalAmount;
        uint256 createdAt;
    }

    // ------------------------
    // Events (PlatformEvents + OrderManagement)
    // ------------------------
    event Logs(string message, uint256 timestamp, string indexed contractName);

    event AddedNewAdmin(
        string message,
        uint256 timestamp,
        string indexed contractName,
        address indexed addedAdminAddress,
        address indexed addedBy
    );

    event RemovedAdmin(
        string message,
        uint256 timestamp,
        string indexed contractName,
        address indexed removedAdminAddress,
        address indexed removedBy
    );

    event AddedNewMerchant(
        string message,
        uint256 timestamp,
        string indexed contractName,
        address indexed addedMerchantId,
        address indexed addedBy
    );

    event UpdatedMerchantBalance(
        string message,
        uint256 timestamp,
        string contractName,
        address indexed updatedBy,
        address indexed merchantId,
        uint256 indexed Amount
    );

    event RemovedMerchant(
        string message,
        uint256 timestamp,
        string indexed contractName,
        address indexed removedMerchantId,
        address indexed removedBy
    );

    event ExternalContractAddressUpdated(
        string message,
        uint256 timestamp,
        string parentContractName,
        address indexed parentContractAddress,
        string addressUpdatedFor_ContractName,
        address indexed newAddressAdded,
        address indexed updatedBy
    );

    /// @notice Order-specific
    event OrderProcessed(
        address indexed payer,
        address indexed token,
        uint256 totalAmount,
        uint256 commission,
        uint256 merchantAmount
    );

    // ------------------------
    // Core__OrderManagement
    // ------------------------
    function getContractName() external pure returns (string memory);

    function getContractOwner() external view returns (address);

    function updateAdminManagementCoreContractAddress(address _newAddress) external;

    function setERC20TokenAddress(address _address) external;

    function getAdminManagementCoreContractAddress() external view returns (address);

    function ping() external view returns (string memory, address, uint256);

    // ------------------------
    // Base__OrderManagement
    // ------------------------
    function getPlatformCommisionWalletAddress() external view returns (address);

    function setPlatformCommisionWalletAddress(address _address) external;

    function getERC20TokenAddress() external view returns (address);

    function getMerchantPayoutAddress() external view returns (address);

    function setMerchantPayoutAddress(address _address) external;

    /// @notice User calls directly via wallet to approve orchestrator SC
    function approveOrderPayment(uint256 _amount, address _orchestratorContractAddress) external;

    /// @notice Orchestrator SC calls to actually process order
    function processOrder__ERC20(
        address _createdBy,
        string memory _orderCID,
        uint256 _totalAmount
    ) external;
}
