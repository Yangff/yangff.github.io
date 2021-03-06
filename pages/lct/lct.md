普通LCT Splay维护到根的链，节点上记录Splay父亲和原树父亲，每次Access后进行操作，Access时会进行若干次链接和Splay操作。

文艺LCT Splay维护到根的链，节点重用Splay的父节点，通过`parent->ch[1] != this && parent->ch[0] != this`来检验是否需要进行一次链接操作，Access时会进行若干次链接和Splay操作。

二逼LCT Splay维护到根的链，节点重用Splay的父节点，然后无脑旋转，一样可以实现LCT的功能！

具体实现也很简单。首先，明确一点，不管什么操作，`Access(x)` 最终都会把`x`转到`root`所在的那颗splay树的根上。也就是说，中间那么多的链接再Splay实际是没有意义的，因为你不会在中间某次操作停下来。

同时，我们重用了父节点。而无论生么情况下，这个父节点都是正确的（链接之后也是往这个父节点转）。而对于被剔除出主链的那个节点，因为剔除出去后，父节点相当于变成了原树的父节点，所以也不需要额外的操作就可以了。

于是就剩下最后一个问题，操作的时候，可能会用到父节点上指向当前节点的`ch[1]`，但是因为我们不需要修改`ch[1]->parent`，所以其实这里只需要假装`parent->ch[1]`已经是我们了，然后旋转就可以了。这只需要修改`getDir()`。把`getDir()`写成`return parent->ch[0] != this;`就行了。

也就是说，LCT和Splay的区别就只在于：
1 首先先链接一下每个点的`parent`，为实际树上的`parent`，但是不要链接父节点的孩子（`ch[0]=ch[1]=NULL`）。
2 修改`getDit()`，从`return parent->ch[1] == this;`改成`return parent->ch[0] != this;`，就可以了。

顺便，Access到根之后，把右孩子一起剪掉就可以了。