

function SearchBar(props) {
    const handleChange = (e) => {
        e.preventDefault();
        props.setSearchVal(e.target.value);
    };
    return (
        <div>
            <input
            type="search"
            placeholder="Find a pokemon..."
            onChange={handleChange}
            value={props.searchVal} />
        </div>
    )
}

export default SearchBar;