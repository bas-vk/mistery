import QtQuick 2.5

List {
    id: rootList
    delegate: Component{
        IconListViewStyle{
            onItemClicked: rootList.itemClicked(item, index)
        }
    }
}
