import Foundation
import RxSwift

/**
 This EndpointGroup communicates with [Merge Request API](https://docs.gitlab.com/ee/api/merge_requests.html)
 # Group API
 ## Valid access levels
 The access levels are defined in the `Gitlab::Access` module. Currently, these levels are recognized:
 ```
 10 => Guest access
 20 => Reporter access
 30 => Developer access
 40 => Maintainer access
 50 => Owner access # Only valid for groups
 ```
 */
public class MergeRequestsEndpointGroup: EndpointGroup {
    internal enum Endpoints {
        case projectsMergeRequests(projectID: Int)

        var url: String {
          switch self {
          case .projectsMergeRequests(let projectID):
            return "/projects/\(projectID)/merge_requests"
          }
        }
    }

    public func getProjectsMergeRequests(projectID: Int, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[MergeRequest]> {
         var queryParams = parameters ?? QueryParameters()
         queryParams["page"] =  page
         queryParams["per_page"] = perPage
         
         let apiRequest = APIRequest(path: Endpoints.projectsMergeRequests(projectID: projectID).url, parameters: queryParams)
         return object(for: apiRequest)
    }

    public func getProjectsMergeRequests(projectID: Int, parameters: QueryParameters? = nil) -> Paginator<MergeRequest> {
         let apiRequest = APIRequest(path: Endpoints.projectsMergeRequests(projectID: projectID).url, parameters: parameters)
         let paginator = Paginator<MergeRequest>(communicator: hostCommunicator, apiRequest: apiRequest)
         return paginator
    }
}
