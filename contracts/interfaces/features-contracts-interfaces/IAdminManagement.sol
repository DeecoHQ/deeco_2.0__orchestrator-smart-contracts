// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

/// @notice Combined interface for Core__AdminManagement and its composed contracts
interface IAdminManagement {
    // ------------------------
    // Structs
    // ------------------------
    struct Admin {
        address adminAddress;
        address addedBy;
        uint256 addedAt;
    }

    struct Merchant {
        address merchantId;
        address addedBy;
        uint256 addedAt;
        uint256 balance;
    }

    // ------------------------
    // Events (from PlatformEvents)
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

    // ------------------------
    // Admin Management (Base__AdminManagement)
    // ------------------------
    function addAdmin(address _address) external;

    function removeAdmin(address _address) external;

    function getPlatformAdmins() external view returns (Admin[] memory);

    function getAdminAdminRegistrations(
        address _adminAddress
    ) external view returns (Admin[] memory);

    function checkIsAdmin(address _adminAddress) external view returns (bool);

    function getAdminProfile(
        address _adminAddress
    ) external view returns (Admin memory);

    // ------------------------
    // Merchant Management (Base__MerchantManagement)
    // ------------------------
    function addMerchant(address _merchantId) external;

    function removeMerchant(address _merchantId) external;

    function getMerchantBalance(address _merchantId)
        external
        view
        returns (uint256);

    function updateMerchantBalance(address _merchantId, uint256 _newBalance)
        external;

    function getPlatformMerchants() external view returns (Merchant[] memory);

    function getMerchantPayoutAddress() external view returns (address);

    function setMerchantPayoutAddress(address _address) external;

    function getAdminMerchantRegistrations(address _adminAddress)
        external
        view
        returns (Merchant[] memory);

    function checkIsMerchant(address _merchantId) external view returns (bool);

    function getMerchantProfile(address _merchantId)
        external
        view
        returns (Merchant memory);

    // ------------------------
    // Core__AdminManagement (extra)
    // ------------------------
    function getContractName() external pure returns (string memory);

    function getContractOwner() external view returns (address);

    function ping()
        external
        view
        returns (string memory, address, uint256);
}
