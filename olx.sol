// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OlxMarketplace {
    struct Product {
        uint id;
        string name;
        string description;
        uint price;
        address payable seller;
        address buyer;
        bool purchased;
    }

    Product[] public products;
    mapping (address=>uint[]) purchases;
    uint public nextProductId = 0;

    modifier onlySeller(uint _productId) {
        require(products[_productId].seller == msg.sender, "You are not the seller of this product");
        _;
    }

    modifier checkPurchased(uint _productId){
        require(products[_productId].purchased,"This product is already sold");
        _;
    }

    function postProduct(string memory _name, string memory _description, uint _price) public {
        require(_price > 0, "Price must be greater than zero");
        products.push(Product(nextProductId, _name, _description, _price, payable(msg.sender),address(0), false));
        nextProductId++;
    }

    function purchaseProduct(uint _productId) public payable {
        Product storage product = products[_productId];
        require(msg.value == product.price, "Please submit the asking price in order to complete the purchase");
        require(!product.purchased, "This product has already been purchased");
        product.seller.transfer(msg.value);
        product.buyer = msg.sender;
        product.purchased = true;
        purchases[msg.sender].push(_productId);
    }

    function deleteProduct(uint _productId) public onlySeller(_productId) checkPurchased(_productId){
        delete products[_productId];
    }

    function editProduct(uint _productId, string memory _name, string memory _description, uint _price) public onlySeller(_productId) {
        Product storage product = products[_productId];
        product.name = _name;
        product.description = _description;
        product.price = _price;
    }
}
