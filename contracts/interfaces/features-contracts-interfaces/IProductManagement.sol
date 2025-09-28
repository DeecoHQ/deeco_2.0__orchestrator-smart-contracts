// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Combined interface for Core__ProductManagement + ProductManagement
interface IProductManagement {
    // ----------------------------
    // Events (from PlatformEvents)
    // ----------------------------
    event Logs(string message, uint256 timestamp, string indexed contractName);

    enum ProductChoreActivityType { AddedNewProduct, UpdatedProduct, DeletedProduct }

    event ProductChore(
        string message,
        uint256 timestamp,
        ProductChoreActivityType indexed activity,
        string contractName,
        string indexed productId,
        address indexed addedBy
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

    // ----------------------------
    // Structs
    // ----------------------------
    struct Product {
        string id;
        address addedBy;
        uint256 addedAt;
        string productImageCID;
        string productMetadataCID;
        uint256 updatedAt;
        address merchantId;
    }

    // ----------------------------
    // Core__ProductManagement functions
    // ----------------------------
    function updateAdminManagementCoreContractAddress(address _newAddress) external;
    function getAdminManagementCoreContractAddress() external view returns(address);
    function getContractName() external pure returns(string memory);
    function getContractOwner() external view returns(address);
    function ping() external view returns(string memory name, address contractAddress);

    // ----------------------------
    // ProductManagement functions
    // ----------------------------
    function addProduct(
        string memory _productId,
        string memory _productImageCID,
        string memory _productMetadataCID,
        address _merchantId
    ) external;

    function deleteProduct(string memory _productId) external;

    function updateProduct(
        string memory _productId,
        string memory _productImageCID,
        string memory _productMetadataCID
    ) external;

    function getProduct(string memory _productId) external view returns (Product memory);

    function getProductsAddedByAdmin(address _adminAddress) external view returns(Product[] memory);

    function getMerchantProducts(address _merchantId) external view returns(Product[] memory);

    function getPlatformProducts() external view returns(Product[] memory);
}
