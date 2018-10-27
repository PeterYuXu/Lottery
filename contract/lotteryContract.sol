pragma solidity ^0.4.21;

contract Lottery {
    //创建合约的地址（管理员）
    address public manager;
    //所有彩民地址的集合
    address[] public players;
    //中奖人的地址
    address public winner;
    //彩票期数
    uint public round = 1;

    constructor () public {
        //设置管理员
        manager = msg.sender;
    }


    //彩民投注函数，所有人均可以参与
    function play() public payable {
        //每次限投 1 ether,可以多次下注
        require(msg.value == 1 ether);
        players.push(msg.sender);
    }

    //修饰器，用来限制只有管理员可以执行函数
    modifier onlyOwner{
        require(manager == msg.sender );
        _;
    }

    //开奖函数，仅管理员可以执行
    function draw() public onlyOwner {
        require(players.length != 0 ); //判断当前是否有人参与
        uint bigInt = uint(sha256(block.difficulty,now,players.length));//通过区块难度，时间，人数进行哈希取值
        uint index = bigInt % players.length;//计算获奖人序号

        winner = players[index];
        winner.transfer(address(this).balance);

        //本期结束后期数加1
        round++;

        //清空所有参与人
        delete players;
    }

    //退款函数，只有管理员可以执行
    function drawback() public onlyOwner{
        require(players.length != 0);

        for (uint i = 0;i < players.length;){
            players[i].transfer(1 ether);//退回钱

            round++;
            delete players;
        }
    }

    //返回参与人数组
    function getPlayers() public view returns (address[]){
        return players;
    }

    //返回当前奖金池金额
    function getAmount() public view returns (uint256){
        return address(this).balance;
    }


    //返回管理员地址
    function getManager() public view returns (address){
        return manager;
    }

    //返回当前期数
    function getRound()public view returns (uint){
        return round;
    }

    //返回中奖者
    function getWinner() public view returns (address){
        return winner;
    }

    //返回当前彩民人数
    function getPlayerCount() public view returns (uint256){
        return players.length;
    }
}
