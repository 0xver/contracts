const { expect } = require("chai")
const { ethers } = require("hardhat")
const deploy = require("../modules/deploy.test.js")

/**
 * @dev Tests ERC20
 */
 describe("", function () {
    it("ERC20", async function () {
        // Gets owner address and second address
        const [addr1, addr2, addr3] = await ethers.getSigners()
    
        // Deploys tokens
        const ERC20Test = await deploy("ERC20Test", 1000000000)
    
        // Token balance of addr1 should equal total supply of 1 billion tokens
        expect(await ERC20Test.balanceOf(addr1.address)).equal(ethers.utils.parseEther("1000000000"))
    
        // Token total supply should equal 1 billion tokens
        expect(await ERC20Test.totalSupply()).equal(ethers.utils.parseEther("1000000000"))
    
        // Transfer half the total supply of tokens to addr2
        expect(await ERC20Test.transfer(addr2.address, ethers.utils.parseEther("500000000")))
    
        // Half the total supply of tokens should be owned by addr1
        expect(await ERC20Test.balanceOf(addr1.address)).equal(ethers.utils.parseEther("500000000"))
    
        // Half the total supply of tokens should be owned by addr2
        expect(await ERC20Test.balanceOf(addr2.address)).equal(ethers.utils.parseEther("500000000"))
    
        // Approve addr2 to spend the remaining of addr1 tokens
        await ERC20Test.connect(addr1).approve(addr2.address, ethers.utils.parseEther("500000000"))
    
        // Transfer the rest of addr1 token balance to addr2 using addr2
        await ERC20Test.connect(addr2).transferFrom(addr1.address, addr2.address, ethers.utils.parseEther("500000000"))
    
        // Token balance of addr2 should equal total supply of 1 billion tokens
        expect(await ERC20Test.balanceOf(addr2.address)).equal(ethers.utils.parseEther("1000000000"))
    
        // Stakes tokens
        await ERC20Test.connect(addr2).stake(ethers.utils.parseEther("1000000000"))
    
        // Token balance of addr2 should equal to 0
        expect(await ERC20Test.balanceOf(addr2.address)).equal(0)
    
        // Speeds up blockchain by 30 days
        await network.provider.send("evm_increaseTime", [30*86400])
        await network.provider.send("evm_mine")
    
        // Claims tokens
        await ERC20Test.connect(addr2).claim()
    
        // Token balance of addr2 should equal total supply of 1 billion tokens
        expect(await ERC20Test.balanceOf(addr2.address)).equal(ethers.utils.parseEther("1000000000"))
    })
})

/**
 * @dev Checks supports interface for ERC20
 */
describe("", function () {
    it("Supports interface for ERC20", async function () {
        // Deploys tokens
        const ERC20Test = await deploy("ERC20Test", 1000000000)
    
        // ERC165 support should return true
        expect(await ERC20Test.supportsInterface(ethers.utils.hexlify(0x01ffc9a7))).equal(true)
    
        // ERC173 support should return true
        expect(await ERC20Test.supportsInterface(ethers.utils.hexlify(0x7f5828d0))).equal(true)
    })
})
