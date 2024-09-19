// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CoolDex {
    event Deposited(
        address indexed account,
        uint256 indexed amount,
        address indexed token
    );
    event OrderCreated(
        address indexed account,
        uint256 amountToSell,
        address indexed tokenToSell,
        uint256 amountToBuy,
        address indexed tokenToBuy,
        uint256 orderId
    );
    event OrderCompleted(
        address indexed seller,
        address indexed buyer,
        uint256 amountSold,
        uint256 amountBought,
        address tokenSold,
        address tokenBought,
        uint256 indexed orderId
    );
    event OrderCancelled(address indexed seller, uint256 indexed orderId);

    error InvalidAddress();
    error InsufficientBalance();
    error InvalidOrder();
    error FailedTransaction();

    uint256 counter;

    struct Order {
        address tokenToSell;
        address tokenToBuy;
        uint256 amountToSell;
        uint256 amountToBuy;
        bool isActive;
    }

    Order[] public orders;

    mapping(uint256 => mapping(address => Order)) userOrders; //keeps track of all orders created
    mapping(address => mapping(address => uint256)) balance; //keeps track of each token balance for a user

    function deposit(uint256 _amount, address _tokenAddress) external {
        if (_tokenAddress == address(0)) revert InvalidAddress();

        uint256 _depositId = counter + 1;

        IERC20 _token = IERC20(_tokenAddress);

        _token.approve(address(this), _amount);
        bool deposited = _token.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        if (!deposited) revert FailedTransaction();

        balance[msg.sender][_tokenAddress] =
            balance[msg.sender][_tokenAddress] +
            _amount;

        counter = _depositId;

        emit Deposited(msg.sender, _amount, _tokenAddress);
    }

    function createOrder(
        uint256 _amountToBuy,
        address _tokenToBuy,
        uint256 _amountToSell,
        address _tokenToSell
    ) external {
        if (_tokenToBuy == address(0)) revert InvalidAddress();
        if (_tokenToSell == address(0)) revert InvalidAddress();

        uint256 _sellerBalance = balance[msg.sender][_tokenToSell];

        if (_sellerBalance < _amountToSell) revert InsufficientBalance();

        uint _orderId = counter + 1;

        _sellerBalance = _sellerBalance - _amountToSell;

        balance[msg.sender][_tokenToSell] = _sellerBalance;

        Order storage _order = userOrders[_orderId][msg.sender];

        _order.tokenToSell = _tokenToSell;
        _order.amountToSell = _amountToSell;
        _order.amountToBuy = _amountToBuy;
        _order.tokenToBuy = _tokenToBuy;
        _order.isActive = true;

        orders.push(_order);

        counter = _orderId;

        emit OrderCreated(
            msg.sender,
            _amountToSell,
            _tokenToSell,
            _amountToBuy,
            _tokenToBuy,
            _orderId
        );
    }

    function getOrder(
        uint256 _orderId,
        address _seller
    ) public view returns (Order memory) {
        return userOrders[_orderId][_seller];
    }

    function acceptOrder(
        uint256 _orderId,
        uint256 _amount,
        address _tokenAddress,
        address _seller
    ) external {
        if (_tokenAddress == address(0)) revert InvalidAddress();

        Order memory _order = getOrder(_orderId, _seller);

        if (_tokenAddress != _order.tokenToBuy) revert InvalidAddress();
        if (_amount < _order.amountToBuy) revert InsufficientBalance();
        if (!_order.isActive) revert InvalidOrder();

        _order.isActive = false;

        IERC20 _token = IERC20(_tokenAddress);

        _token.approve(address(this), _amount);
        bool deposited = _token.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        if (!deposited) revert FailedTransaction();

        bool withdrawn = IERC20(_order.tokenToSell).transfer(
            msg.sender,
            _order.amountToSell
        );
        if (!withdrawn) revert FailedTransaction();

        balance[_seller][_tokenAddress] =
            balance[_seller][_tokenAddress] +
            _amount;

        emit OrderCompleted(
            _seller,
            msg.sender,
            _order.amountToSell,
            _amount,
            _order.tokenToSell,
            _tokenAddress,
            _orderId
        );
    }

    function cancelOrder(uint256 _orderId) external {
        if (msg.sender == address(0)) revert InvalidAddress();

        Order storage _order = userOrders[_orderId][msg.sender];

        if (!_order.isActive) revert InvalidOrder();

        _order.isActive = false;

        emit OrderCancelled(msg.sender, _orderId);
    }

    function getUserBalance(
        address _account,
        address _tokenAddress
    ) internal view returns (uint256) {
        return balance[_account][_tokenAddress];
    }

    function withdraw(uint256 _amount, address _tokenAddress) external {
        if (msg.sender == address(0)) revert InvalidAddress();
        if (_tokenAddress == address(0)) revert InvalidAddress();

        uint256 _balance = getUserBalance(msg.sender, _tokenAddress);

        if (_amount > _balance) revert InsufficientBalance();

        _balance = _balance - _amount;

        balance[msg.sender][_tokenAddress] = _balance;

        bool withdrawn = IERC20(_tokenAddress).transfer(msg.sender, _amount);
        if (!withdrawn) revert FailedTransaction();
    }
}
