const { expect } = require("chai")
const { ethers } = require("hardhat")
const deploy = require("../modules/deploy.test.js")
const { MerkleTree } = require("merkletreejs")
const keccak256 = require("keccak256")
const whitelist = require("./whitelist.json")

/**
 * @dev Merkle tree functions
 */
function merkle(whitelist) {
    const leafNodes = whitelist.map(addr => keccak256(addr))
    const merkleTree = new MerkleTree(leafNodes, keccak256, {sortPairs: true})
    const rootHash = merkleTree.getRoot()
    const root = "0x" + rootHash.toString("hex")
    return [merkleTree, root]
}

function proof(whitelist, addr) {
    var whitelistAddress = keccak256(addr.address)
    var merkleProof = merkle(whitelist)[0].getHexProof(whitelistAddress)
    return merkleProof
}

/**
 * @dev Tests ERC721
 */
describe("", function () {
    it("ERC721", async function () {
        // Gets owner address and second address
        const [addr1, addr2, addr3] = await ethers.getSigners()
    
        // Deploys tokens
        const ERC721Test = await deploy("ERC721Test")

        // Token balance for addr1 should equal 0
        expect(await ERC721Test.balanceOf(addr1.address)).equal(0)
    
        // Should return false
        expect(await ERC721Test.paused()).equal(true)
    
        // Initiate minting
        await ERC721Test.pause(false)
    
        // Should return true
        expect(await ERC721Test.paused()).equal(false)
    
        // Mint with addr2
        await ERC721Test.connect(addr2).publicMint(1)
    
        // Token balance for addr2 should equal 1
        expect(await ERC721Test.balanceOf(addr2.address)).equal(1)
    
        // Token owner of ID 1 should be addr2
        expect(await ERC721Test.ownerOf(1)).equal(addr2.address)
    
        // Set merkle root
        await ERC721Test.setMerkleRoot(merkle(whitelist)[1])

        // Mint with addr1
        await ERC721Test.connect(addr1).privateMint(1, proof(whitelist, addr1))
    
        // Token balance for addr1 should equal 1
        expect(await ERC721Test.balanceOf(addr1.address)).equal(1)
    
        // Token owner of ID 2 should be addr1
        expect(await ERC721Test.ownerOf(2)).equal(addr1.address)
    
        // Token URI should be prereveal
        expect(await ERC721Test.tokenURI(1)).equal("ipfs://cid/prereveal.json")
    
        // Check reveal URI
        expect(await ERC721Test.checkURI(1)).equal("ipfs://QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/1")
        expect(await ERC721Test.checkURI(2)).equal("ipfs://QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/2")
        expect(await ERC721Test.checkURI(0)).equal("Token ID out of range")
        expect(await ERC721Test.checkURI(3)).equal("Token ID out of range")
    
        // Reveal tokens
        await ERC721Test.connect(addr1).reveal()
    
        // Stop check
        expect(await ERC721Test.checkURI(1)).equal("Tokens have been revealed")
    
        // Token URI should return correct identifier
        expect(await ERC721Test.tokenURI(1)).equal("ipfs://QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/1")
        expect(await ERC721Test.tokenURI(2)).equal("ipfs://QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/2")
        expect(await ERC721Test.tokenURI(0)).equal("Token ID out of range")
        expect(await ERC721Test.tokenURI(3)).equal("Token ID out of range")
    
        // Transfer token ID 1 from addr2 to addr3
        await ERC721Test.connect(addr2).transferFrom(addr2.address, addr3.address, 1)
    
        // Token owner of ID 1 should be addr2
        expect(await ERC721Test.ownerOf(1)).equal(addr3.address)
    
        // Token balance for addr3 should equal 2
        expect(await ERC721Test.balanceOf(addr3.address)).equal(1)
    
        // Approve addr1 to spend addr3 tokens
        await ERC721Test.connect(addr3).approve(addr1.address, 1)
    
        // Spend addr3 tokens with addr1
        await ERC721Test.connect(addr1).transferFrom(addr3.address, addr1.address, 1)
    
        // Test airdrop
        await ERC721Test.airdrop(addr1.address, 1)
    })
})

/**
 * @dev Checks supports interface for ERC721
 */
describe("", function () {
    it("Supports interface for ERC721", async function () {
        // Deploys tokens
        const ERC721Test = await deploy("ERC721Test")

        // ERC165 support should return true
        expect(await ERC721Test.supportsInterface(ethers.utils.hexlify(0x01ffc9a7))).equal(true)
    
        // ERC173 support should return true
        expect(await ERC721Test.supportsInterface(ethers.utils.hexlify(0x7f5828d0))).equal(true)
    
        // ERC721 support should return true
        expect(await ERC721Test.supportsInterface(ethers.utils.hexlify(0x80ac58cd))).equal(true)
    
        // ERC721Metadata support should return true
        expect(await ERC721Test.supportsInterface(ethers.utils.hexlify(0x5b5e139f))).equal(true)
    
        // ERC721Receiver support should return true
        expect(await ERC721Test.supportsInterface(ethers.utils.hexlify(0x150b7a02))).equal(true)
    
        // ERC2981 support should return true
        //expect(await ERC721Test.supportsInterface(ethers.utils.hexlify(0x2a55205a))).equal(true)
    })
})
