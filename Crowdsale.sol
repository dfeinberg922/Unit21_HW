pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, TimedCrowdsale, RefundableCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,
        address payable wallet,
        PupperCoin token, 
        uint goal,
        uint cap,
        uint OpenTime,
        uint CloseTime
    )

        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        CappedCrowdsale(goal)
        TimedCrowdsale(OpenTime, CloseTime)
        RefundableCrowdsale (goal)
        RefundablePostDeliveryCrowdsale()
        public

    {

    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet
    )

        public
    {

        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        uint goal = 3000000000000000000 wei;
        uint cap = 3000000000000000000 wei; 

        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token, goal, cap, now, now + 24 weeks);
        token_sale_address = address(pupper_sale);

        // PupperCoin contract is the minter
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }