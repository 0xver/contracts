module.exports = async function deploy(name) {
    var token = await ethers.getContractFactory(name)
    const contract = await token.deploy()
    return contract
}
