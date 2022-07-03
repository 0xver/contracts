const { expect } = require("chai")
const { ethers } = require("hardhat")
const deploy = require("../modules/deploy.test.js")

/**
 * @dev Tests ERC1155
 */
describe("", function () {
    it("ERC1155", async function () {
        // Gets owner address and second address
        const [addr1, addr2, addr3, addr4] = await ethers.getSigners()
    
        // Deploys tokens
        const ERC1155Test = await deploy("ERC1155Test")
    
        // Token balance #1 for addr1 should equal 0
        expect(await ERC1155Test.balanceOf(addr1.address, 1)).equal(0)
    
        // Initiate token ID #1
        await ERC1155Test.initTokenId("QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/1")
    
        // Mint 500 tokens
        await ERC1155Test.mint(addr1.address, 500)
    
        // Token balance #1 for addr1 should equal 500
        expect(await ERC1155Test.balanceOf(addr1.address, 1)).equal(500)
    
        // Transfer 200 tokens of token ID #1 from addr1 to addr2
        await ERC1155Test.safeTransferFrom(addr1.address, addr2.address, 1, 200, 0x0)
    
        // Token balance #1 for addr1 should equal 300
        expect(await ERC1155Test.balanceOf(addr1.address, 1)).equal(300)
    
        // Token balance #1 for addr2 should equal 200
        expect(await ERC1155Test.balanceOf(addr2.address, 1)).equal(200)
    
        // Approve addr3 to spend the tokens of addr2
        await ERC1155Test.connect(addr2).setApprovalForAll(addr3.address, true)
    
        // Check addr3 to spend the tokens of addr2
        expect(await ERC1155Test.isApprovedForAll(addr2.address, addr3.address)).equal(true)
    
        // Transfer 200 tokens of token ID #1 from addr1 to addr2
        await ERC1155Test.connect(addr3).safeTransferFrom(addr2.address, addr3.address, 1,100, 0x0)
    
        // Mint more tokens for ID #1 to addr4
        await ERC1155Test.mint(addr4.address, 600)
    
        // Initiate token ID #2
        await ERC1155Test.initTokenId("QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/2")
    
        // Mint 2500 tokens
        await ERC1155Test.mint(addr4.address, 2500)
    
        // Token balance #1 for addr3 should equal 100
        expect(await ERC1155Test.balanceOf(addr3.address, 1)).equal(100)
    
        // Token balance #1 for addr4 should equal 600
        expect(await ERC1155Test.balanceOf(addr4.address, 1)).equal(600)
    
        // Token balance #2 for addr4 should equal 2500
        expect(await ERC1155Test.balanceOf(addr4.address, 2)).equal(2500)
    
        // Token URI for #1 should be correct identifier
        expect(await ERC1155Test.uri(1)).equal("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/1")
    
        // Token URI for #2 should be correct identifier
        expect(await ERC1155Test.uri(2)).equal("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/2")
    })
})

/**
 * @dev Checks supports interface for ERC1155
 */
 describe("", function () {
    it("Supports interface for ERC1155", async function () {
        // Deploys tokens
        const ERC1155Test = await deploy("ERC1155Test")

        // ERC165 support should return true
        expect(await ERC1155Test.supportsInterface(ethers.utils.hexlify(0x01ffc9a7))).equal(true)
    
        // ERC173 support should return true
        expect(await ERC1155Test.supportsInterface(ethers.utils.hexlify(0x7f5828d0))).equal(true)
    
        // ERC1155 support should return true
        expect(await ERC1155Test.supportsInterface(ethers.utils.hexlify(0xd9b67a26))).equal(true)
    
        // ERC1155Metadata support should return true
        expect(await ERC1155Test.supportsInterface(ethers.utils.hexlify(0x0e89341c))).equal(true)
    
        // ERC1155Receiver support should return true
        expect(await ERC1155Test.supportsInterface(ethers.utils.hexlify(0x4e2312e0))).equal(true)
    })
})
