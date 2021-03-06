pragma solidity ^0.4.21;

import "ds-token/token.sol";
import "ds-chief/chief.sol";

contract VoteProxy {
  address cold;
  address hot;
  DSToken gov;
  DSToken iou;
  DSChief chief;

  function VoteProxy(DSToken gov_, DSChief chief_, DSToken iou_, address cold_, address hot_) {
    cold = cold_;
    hot = hot_;
    gov = gov_;
    chief = chief_;
    iou = iou_;
  }

  function approve(uint amt) {
    require(msg.sender == cold);
    gov.approve(chief, amt);
    iou.approve(chief, amt);
  }

  function lock(uint amt) public {
    require(msg.sender == cold);
    chief.lock(amt);
  }

  function free(uint amt) public {
    require(msg.sender == cold);
    chief.free(amt);
  }

  function withdraw(uint amt) public {
    require(msg.sender == cold);
    gov.transfer(cold, amt);
  }

  // actions which can be called from the hot wallet
  function vote(address[] yays) public returns (bytes32 slate) {
    require(msg.sender == hot || msg.sender == cold);
    return chief.vote(yays);
  }

  function vote(bytes32 slate) public {
    require(msg.sender == hot || msg.sender == cold);
    chief.vote(slate);
  }

  function etch(address[] yays) public returns (bytes32 slate) {
    require(msg.sender == hot || msg.sender == cold);
    return chief.etch(yays);
  }

  // lock proxy cold
  // free proxy cold
}
