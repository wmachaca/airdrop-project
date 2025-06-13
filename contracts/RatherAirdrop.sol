//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract RatherAirdrop is Ownable {
    using SafeERC20 for IERC20; //for all ERC20 use SafeERC20
    error RatherAirdrop__InvalidProof();
    error RatherAirdrop__AlreadyClaimed();

    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;

    bool public isPaused;
    uint256 public totalTokensToDistribute;
    uint256 public totalTokensClaimed;   

    struct Claim {
        uint256 totalAmount;
        uint256 claimedAmount;
    }     

    mapping(address => Claim) public s_hasClaimed; // check latter
    address[] public claimers;

    event TokensClaimed(address indexed user, uint256 amount);
    event AirdropPaused(bool isPaused);
    event TokensRecovered(uint256 amount);
    
    constructor(bytes32 _merkleRoot, IERC20 _airdropToken, uint256 _totalTokens) Ownable(msg.sender) {
        i_merkleRoot = _merkleRoot;
        i_airdropToken = _airdropToken;
        totalTokensToDistribute = _totalTokens;
    }

    function claim(address account, uint256 totalAmount, uint256 claimAmount, bytes32[] calldata merkleProof) external {
        require(!isPaused, "Airdrop is paused");
        require(claimAmount > 0, "Claim amount must be > 0");

        Claim storage userClaim = s_hasClaimed[account];//reference of s_hasClaimed

        if (userClaim.totalAmount == 0) {            
            bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encodePacked(account, totalAmount))));
            require(MerkleProof.verify(merkleProof, i_merkleRoot, leaf), "Invalid Merkle Proof");
            userClaim.totalAmount = totalAmount;
            claimers.push(account);
        }

        require(userClaim.claimedAmount + claimAmount <= userClaim.totalAmount, "Exceeds eligible amount");

        userClaim.claimedAmount += claimAmount;
        totalTokensClaimed += claimAmount;

        //require(i_airdropToken.safeTransfer(account, claimAmount), "Token transfer failed"); //revert without require
        i_airdropToken.safeTransfer(account, claimAmount);

        emit TokensClaimed(account, claimAmount);
    }

    function pauseAirdrop(bool _pause) external onlyOwner {
        isPaused = _pause;
        emit AirdropPaused(_pause);
    }    

    function recoverUnclaimedTokens() external onlyOwner {
        require(isPaused, "Pause the airdrop first");

        uint256 balance = i_airdropToken.balanceOf(address(this));//of the contract
        uint256 unclaimed = totalTokensToDistribute - totalTokensClaimed;
        uint256 toRecover = balance < unclaimed ? balance : unclaimed;

        //require(i_airdropToken.safeTransfer(owner(), toRecover), "Recovery transfer failed");
        i_airdropToken.safeTransfer(owner(), toRecover);
        
        emit TokensRecovered(toRecover);
    }


    function getRecentClaimers(uint256 count) external view returns (
        address[] memory recentAddresses,
        uint256[] memory recentAmounts
    ) {
        uint256 total = claimers.length;
        uint256 actualCount = count > total ? total : count;
        recentAddresses = new address[](actualCount);
        recentAmounts = new uint256[](actualCount);

        for (uint256 i = 0; i < actualCount; i++) {
            uint256 index = total - 1 - i;
            address user = claimers[index];
            recentAddresses[i] = user;
            recentAmounts[i] = s_hasClaimed[user].claimedAmount;
        }

        return (recentAddresses, recentAmounts);
    }    

    function getAirdropStatus() external view returns (
        uint256 distributed,
        uint256 claimed,
        uint256 remaining,
        bool paused
    ) {
        return (
            totalTokensToDistribute,
            totalTokensClaimed,
            totalTokensToDistribute - totalTokensClaimed,
            isPaused
        );
    }    

    function getMerkleRoot() external view returns(bytes32) {
        return i_merkleRoot;
    }
    function getAirdropToken() external view returns(IERC20) {
        return i_airdropToken;
    }    
}