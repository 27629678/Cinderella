local NEIAPStoreManager = class("NEIAPStoreManager")

NEIAPStoreManager.LOAD_PRODUCTS_FINISHED    = "LOAD_PRODUCTS_FINISHED"
NEIAPStoreManager.LOAD_PRODUCTS_FAILED      = "LOAD_PRODUCTS_FAILED"
NEIAPStoreManager.TRANSACTION_PURCHASED     = "TRANSACTION_PURCHASED"
NEIAPStoreManager.TRANSACTION_RESTORED      = "TRANSACTION_RESTORED"
NEIAPStoreManager.TRANSACTION_FAILED        = "TRANSACTION_FAILED"
NEIAPStoreManager.TRANSACTION_UNKNOWN_ERROR = "TRANSACTION_UNKNOWN_ERROR"

function NEIAPStoreManager:ctor()
	-- 允许使用协议及委托
	require("framework.api.EventProtocol").extend(self)

	self.provider = require(cc.PACKAGE_NAME .. ".api.Store")
    self.provider.init(handler(self, self.transactionCallback))
    self.products = {}
end

function NEIAPStoreManager:canMakePurchases()
    return self.provider.canMakePurchases()
end

function NEIAPStoreManager:loadProducts(productsId)
    self.provider.loadProducts(productsId, function(event)
        self.products = {}
        for _, product in ipairs(event.products) do
            self.products[product.productIdentifier] = clone(product)
        end

        if event.products then
            self:dispatchEvent({
                name = NEIAPStoreManager.LOAD_PRODUCTS_FINISHED,
                products = event.products,
                invalidProducts = event.invalidProducts
            })
        end

        if event.errorString then
            self:dispatchEvent({
                name    = NEIAPStoreManager.LOAD_PRODUCTS_FAILED,
                errorString = event.errorString
            })
        end
    end)
end

function NEIAPStoreManager:isProductLoaded(productId)
    return self.provider.isProductLoaded(productId)
end

function NEIAPStoreManager:cancelLoadProducts()
    self.provider.cancelLoadProducts()
end

function NEIAPStoreManager:getProductDetails(productId)
    local product = self.products[productId]
    if product then
        return clone(product)
    else
        return nil
    end
end

function NEIAPStoreManager:purchaseProduct(productId)
    self.provider.purchase(productId)
end

function NEIAPStoreManager:restoreProducts()
	self.provider.restore()
end

function NEIAPStoreManager:transactionCallback(event)
    local transaction = event.transaction
    if transaction.state == "purchased" then
        print("Transaction succuessful!")
        print("productIdentifier", transaction.productIdentifier)
        print("quantity", transaction.quantity)
        print("transactionIdentifier", transaction.transactionIdentifier)
        print("date", os.date("%Y-%m-%d %H:%M:%S", transaction.date))
        print("receipt", transaction.receipt)
        self:dispatchEvent({
            name = NEIAPStoreManager.TRANSACTION_PURCHASED,
            transaction = transaction,
        })
    elseif  transaction.state == "restored" then
        print("Transaction restored (from previous session)")
        print("productIdentifier", transaction.productIdentifier)
        print("receipt", transaction.receipt)
        print("transactionIdentifier", transaction.identifier)
        print("date", transaction.date)
        print("originalReceipt", transaction.originalReceipt)
        print("originalTransactionIdentifier", transaction.originalIdentifier)
        print("originalDate", transaction.originalDate)
        self:dispatchEvent({
            name = NEIAPStoreManager.TRANSACTION_RESTORED,
            transaction = transaction,
        })
    elseif transaction.state == "failed" then
        print("Transaction failed")
        print("errorCode", transaction.errorCode)
        print("errorString", transaction.errorString)
        self:dispatchEvent({
            name = NEIAPStoreManager.TRANSACTION_FAILED,
            transaction = transaction,
        })
    else
        print("unknown event")
        self:dispatchEvent({
            name = NEIAPStoreManager.TRANSACTION_UNKNOWN_ERROR,
            transaction = transaction,
        })
    end

    -- Once we are done with a transaction, call this to tell the store
    -- we are done with the transaction.
    -- If you are providing downloadable content, wait to call this until
    -- after the download completes.
    self.provider.finishTransaction(transaction)
end

function NEIAPStoreManager:finishTransaction(transaction)
    self.provider.finishTransaction(transaction)
end

return NEIAPStoreManager