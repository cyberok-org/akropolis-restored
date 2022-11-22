import { 
    PoolContract, PoolInstance, 
    StakingPoolContract,StakingPoolInstance,
    StakingPoolADELContract,StakingPoolADELInstance,
    FreeERC20Contract,FreeERC20Instance,
    RewardVestingModuleContract, RewardVestingModuleInstance,
} from "../../../types/truffle-contracts/index";


const { BN, constants, expectEvent, shouldFail, time } = require("@openzeppelin/test-helpers");
const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const UPGRADABLE_OPTS = {
    unsafeAllowCustomTypes: true
};

import Snapshot from "./../../utils/snapshot";
const should = require("chai").should();
var expect = require("chai").expect;
const expectRevert= require("./../../utils/expectRevert");
const expectEqualBN = require("./../../utils/expectEqualBN");
const w3random = require("./../../utils/w3random");

const FreeERC20 = artifacts.require("FreeERC20");

const Pool = artifacts.require("Pool");
const StakingPool  =  artifacts.require("StakingPool");
const RewardVestingModule = artifacts.require("RewardVestingModule");

contract("StakingPool", async ([owner, user, ...otherAccounts]) => {


    let pool:PoolInstance;
    let akro:FreeERC20Instance;
    let stakingPoolAkro:StakingPoolInstance;
    let rewardVesting:RewardVestingModuleInstance;


    before(async () => {
        //Setup system contracts
        pool = await Pool.new();
        await pool.methods['initialize()']();

        akro = await FreeERC20.new();
        await akro.methods['initialize(string,string)']("Akropolis", "AKRO");
        await pool.set('akro', akro.address, false);

        stakingPoolAkro = await StakingPool.new();
        await stakingPoolAkro.methods['initialize(address,address,uint256)'](pool.address, akro.address, '0');
        await pool.set('staking', stakingPoolAkro.address, false);

        rewardVesting = await RewardVestingModule.new();
        await rewardVesting.methods['initialize(address)'](pool.address);
        await pool.set('reward', rewardVesting.address, false);
        await stakingPoolAkro.setRewardVesting(rewardVesting.address);


        //Prepare rewards
        let rewardsAmount = new BN(web3.utils.toWei('1000', 'ether'));
        let now = Number(await time.latest());
        await rewardVesting.registerRewardToken(stakingPoolAkro.address, akro.address, String(now - 7*24*60*60), {from:owner});
        await akro.methods['mint(uint256)'](rewardsAmount.muln(2), {from:owner});
        await akro.approve(rewardVesting.address, rewardsAmount.muln(2), {from:owner});
        await rewardVesting.createEpoch(stakingPoolAkro.address, akro.address, String(now+2*7*24*60*60), rewardsAmount, {from:owner});
        await rewardVesting.createEpoch(stakingPoolAkro.address, akro.address, String(now+50*7*24*60*60), rewardsAmount, {from:owner});

        //Save snapshot
        //snap = await Snapshot.create(web3.currentProvider);
        
    });

    beforeEach(async () => {
        //await snap.revert();
    });


    it('should stake AKRO 10 times', async () => {
        for(let i=0; i<10; i++){
            let amount = w3random.interval(10, 20, 'ether');
            console.log(`Iteration ${i}: staking ${web3.utils.fromWei(amount)} AKRO.`);
            await prepareTokenSpending(akro, user, stakingPoolAkro.address, amount);
            await stakingPoolAkro.stake(amount, "0x", {from:user});
            await stakingPoolAkro.claimRewardsFromVesting({from:owner});
            await time.increase(7*24*60*60);
        }
    });

    it('should withdraw all stakes with gas used < 200k', async () => {
        let tx = await stakingPoolAkro.unstakeAllUnlocked("0x", {from:user});
        //console.log(tx);
        let gasUsed = tx.receipt.gasUsed;
        expect(gasUsed).to.be.lt(200000);
    });



    async function prepareTokenSpending(token:FreeERC20Instance, sender:string, spender:string, amount: BN){
        await token.allocateTo(sender, amount, {from:sender});
        await token.approve(spender, amount, {from:sender});
    }

});
