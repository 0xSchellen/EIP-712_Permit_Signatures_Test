// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.14;

import {ERC20} from "solmate/tokens/ERC20.sol";

/// @title Deposit
/// @author kulkarohan
/// @notice Mock contract to transfer ERC-20 tokens with a signed approval

contract Deposit {
    event TokenDeposit(address user, address tokenContract, uint256 amount);
    event TokenWithdraw(address user, address tokenContract, uint256 amount);

    /// @notice The number of tokens stored for a given user and token contract
    /// @dev User => ERC-20 address => Number of tokens deposited
    mapping(address => mapping(address => uint256)) public userDeposits;


    /// @notice Deposits ERC-20 tokens (requires pre-approval)
    /// @param _tokenContract The ERC-20 token address
    /// @param _amount The number of tokens

    function deposit(address _tokenContract, uint256 _amount) external {
        ERC20(_tokenContract).transferFrom(msg.sender, address(this), _amount);
        userDeposits[msg.sender][_tokenContract] += _amount;
        emit TokenDeposit(msg.sender, _tokenContract, _amount);
    }

    /// @notice Deposits ERC-20 tokens with a signed approval
    /// @param _tokenContract The ERC-20 token address
    /// @param _amount The number of tokens to transfer
    /// @param _owner The user signing the approval
    /// @param _spender The user to transfer the tokens (ie this contract)
    /// @param _value The number of tokens to appprove the spender
    /// @param _deadline The timestamp the permit expires
    /// @param _v The 129th byte and chain id of the signature
    /// @param _r The first 64 bytes of the signature
    /// @param _s Bytes 64-128 of the signature
    function depositWithPermit(
        address _tokenContract,
        uint256 _amount,
        address _owner,
        address _spender,
        uint256 _value,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external {
        ERC20(_tokenContract).permit(
            _owner,
            _spender,
            _value,
            _deadline,
            _v,
            _r,
            _s
        );
        ERC20(_tokenContract).transferFrom(_owner, address(this), _amount);
        userDeposits[_owner][_tokenContract] += _amount;
        emit TokenDeposit(_owner, _tokenContract, _amount);
    }

    function withdraw(address _tokenContract, uint256 _amount) external {
        require(
            _amount <= userDeposits[msg.sender][_tokenContract],
            "INVALID_WITHDRAW"
        );
        userDeposits[msg.sender][_tokenContract] -= _amount;
        ERC20(_tokenContract).transfer(msg.sender, _amount);
        emit TokenWithdraw(msg.sender, _tokenContract, _amount);
    }
}
