import AltairMDKProviders

public enum CounterAPI {
    private static let baseUrl = "http://127.0.0.1:3000/api/v1"
    
    private static let defaultHeaders = [
        "Content-Type": "application/json"
    ]
    
    public static func getCounters<APIResponse>() -> Endpoint<APIResponse> {
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .get, path: "/counters")
    }
    
    public static func createCounter<APIResponse>(title: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["title"] = [title]
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .post, path: "/counter", parameters: params)
    }
    
    public static func incrementCounter<APIResponse>(id: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["id"] = [id]
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .post, path: "/counter/inc", parameters: params)
    }
    
    public static func decrementCounter<APIResponse>(id: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["id"] = [id]
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .post, path: "/counter/dec", parameters: params)
    }
    
    public static func deleteCounter<APIResponse>(id: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["id"] = [id]
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .delete, path: "/counter", parameters: params)
    }
    
}
