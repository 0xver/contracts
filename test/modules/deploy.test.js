module.exports = async function deploy(name, constructor=null) {
    var token = await ethers.getContractFactory(name)
    if (constructor == null) {
        const contract = await token.deploy()
        return contract
    } else if (constructor != null) {
        const contract = await token.deploy(constructor)
        return contract
    }
}
