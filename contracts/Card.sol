pragma solidity ^0.8.17;

contract CardChain {
    string public name = "Diploma Chain";
    string public symbol = "DChain";
    address private _owner;
    bool private pause = false;

    uint256 public cardCount = 0;

    struct Card {
        uint256 id;
        address payable author;
        string authorName;
        string nomeFaculdade;
        string nomeDiretorGeral;
        string nomeSecretariaAcademica;
        string nomeCurso;
        string nomeAluno;
        string documentoAluno;
        uint256 qtdDisciplinasConcluida;
        uint256 cargaHoraria;
    }

    mapping(uint256 => Card) public cards;

    event CreateCard(
        uint256 indexed id,
        address author,
        string authorName,
        string nomeFaculdade,
        string nomeDiretorGeral,
        string nomeSecretariaAcademica,
        string nomeCurso,
        string nomeAluno,
        string documentoAluno,
        uint256 qtdDisciplinasConcluida,
        uint256 cargaHoraria
    );

    event SendTip(uint256 indexed cardId, address donor, address author);

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "You aren't a owner");
        _;
    }

    modifier whenPaused() {
        require(!pause, "CardChain: contract paused");
        _;
    }

    function createCard(
        string memory nomeFaculdade_,
        string memory authorName_,
        string memory nomeDiretorGeral_,
        string memory nomeSecretariaAcademica_,
        string memory nomeCurso_,
        string memory nomeAluno_,
        string memory documentoAluno_,
        uint256 qtdDisciplinasConcluida_,
        uint256 cargaHoraria_
    ) public whenPaused {
        cardCount = ++cardCount;

        emit CreateCard(
            cardCount,
            msg.sender,
            authorName_,
            nomeFaculdade_,
            nomeDiretorGeral_,
            nomeSecretariaAcademica_,
            nomeCurso_,
            nomeAluno_,
            documentoAluno_,
            qtdDisciplinasConcluida_,
            cargaHoraria_
        );

        cards[cardCount] = Card(
            cardCount,
            payable(msg.sender),
            authorName_,
            nomeFaculdade_,
            nomeDiretorGeral_,
            nomeSecretariaAcademica_,
            nomeCurso_,
            nomeAluno_,
            documentoAluno_,
            qtdDisciplinasConcluida_,
            cargaHoraria_
        );
    }

    function findCardById(uint256 id_) public view returns (Card memory) {
        return cards[id_];
    }

    function setTipToAuthor(uint256 id_, uint256 value)
        public
        payable
        whenPaused
    {
        require(cards[id_].id > 0, "CardChain: not exist the card");
        require(
            msg.value > 0 && value > 0 && msg.value == value,
            "CardChain: send any tip"
        );

        uint256 platformCost = 5;
        uint256 cost = (msg.value * platformCost) / 100;
        uint256 tip = msg.value - cost;

        emit SendTip(id_, msg.sender, cards[id_].author);

        payable(cards[id_].author).transfer(tip);
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function getBalanceOf(address owner_) public view returns (uint256) {
        return address(owner_).balance;
    }

    function ownerOf(uint256 id_) public view returns (address) {
        return cards[id_].author;
    }

    function fetchAllCards() public view returns (Card[] memory) {
        Card[] memory cardList = new Card[](cardCount);

        if (cardCount == 0) {
            return cardList;
        }

        for (uint256 i = 0; i < cardCount; i++) {
            cardList[i] = cards[i + 1];
        }

        return cardList;
    }
}
