using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.WindowsAzure.Storage.Table;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.Azure.Cosmos;
using System.Net;
using Microsoft.WindowsAzure.Storage;
using Microsoft.Extensions.Configuration;

namespace CuauhFunctionsApp
{
    public static class VisitorCounterFunction
    {

        [FunctionName("VisitorCount")]
        public static async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req,
        ILogger log,
        ExecutionContext context)
        {
            try
            {

                var config = new ConfigurationBuilder()
                .SetBasePath(context.FunctionAppDirectory)
                .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();

                var storageConnectionString = config["STORAGE_CONNECTION_STRING"];
                
                var storageAccount = CloudStorageAccount.Parse(storageConnectionString);

                var tableClient = storageAccount.CreateCloudTableClient();
                var table = tableClient.GetTableReference("BlogView");

                if (req.Method.Equals("GET", StringComparison.OrdinalIgnoreCase))
                {
                    var retrieveOperation = TableOperation.Retrieve<VisitorCount>("Count", "Total");
                    var result = await table.ExecuteAsync(retrieveOperation);

                    var visitorCount = (result.Result as VisitorCount)?.Count ?? 0;

                    return new OkObjectResult(visitorCount);
                }
                else if (req.Method.Equals("POST", StringComparison.OrdinalIgnoreCase))
                {
                    var retrieveOperation = TableOperation.Retrieve<VisitorCount>("Count", "Total");
                    var result = await table.ExecuteAsync(retrieveOperation);
                    
                    var visitorCount = (result.Result as VisitorCount) ?? new VisitorCount("Count", "Total");
                    visitorCount.Count++;

                    var insertOrReplaceOperation = TableOperation.InsertOrReplace(visitorCount);
                    await table.ExecuteAsync(insertOrReplaceOperation);

                    return new OkResult();
                }
                else
                {
                    return new BadRequestResult();
                }
            }
            catch (Exception ex)
            {
                log.LogError(ex, "An error occurred.");
                return new StatusCodeResult((int)HttpStatusCode.InternalServerError);
            }
        }
    }

    public class VisitorCount : TableEntity
    {
        public VisitorCount(string partitionKey, string rowKey)
        {
            PartitionKey = partitionKey;
            RowKey = rowKey;
        }

        public VisitorCount() { }

        public int Count { get; set; }
    }
}